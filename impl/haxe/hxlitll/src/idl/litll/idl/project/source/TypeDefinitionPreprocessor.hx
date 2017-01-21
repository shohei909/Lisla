package litll.idl.project.source;

import haxe.ds.Option;
import litll.core.LitllString;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.core.ds.Set;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.project.error.IdlReadErrorKind;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.data.idl.StructFieldName;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypeDependenceName;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeParameterDeclaration;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.TypeReferenceParameter;
import litll.idl.std.data.idl.TypeReferenceParameterKind;
import litll.idl.std.delitllfy.idl.TypeReferenceDelitllfier;
using litll.idl.std.tools.idl.TypeDefinitionTools;

class TypeDefinitionPreprocessor
{
	private var parent:IdlPreprocessor;
	private var target:TypeDefinition;
	private var typeParameters:Map<String, TypeName>;
	
	public static function run(parent:IdlPreprocessor, target:TypeDefinition):Void
	{
		var runner = new TypeDefinitionPreprocessor(parent, target);
		runner.processTypeParameters();
		runner.processBody();
	}
	
	private function new(parent:IdlPreprocessor, target:TypeDefinition)
	{
		this.parent = parent;
		this.target = target;
	}
	
	private function processTypeParameters():Void
	{
		var typeDependences = new Map<String, TypeDependenceName>();
		this.typeParameters = new Map<String, TypeName>();
		
		for (typeParameter in target.getTypeParameters())
		{
			switch (typeParameter)
			{
				case TypeParameterDeclaration.TypeName(typeName):
                    if (typeParameters.exists(typeName.toString()))
					{
						addError(IdlReadErrorKind.TypeParameterNameDupplicated(typeName));
					}
					else
					{
						typeParameters.set(typeName.toString(), typeName);
					}
					
				case TypeParameterDeclaration.Dependence(dependence):
                    var name = dependence.name;
					if (typeDependences.exists(name.toString()))
					{
						addError(IdlReadErrorKind.TypeDependenceNameDupplicated(name));
					}
					else
					{
						typeDependences.set(name.toString(), name);
					}
			}
		}
	}
	
	private function processBody():Void
	{
		switch (target)
		{
			case TypeDefinition.Newtype(_, type):
				processTypeReference(type);
				
			case TypeDefinition.Enum(_, constructors):
				processEnumConstuctors(constructors);
				
			case TypeDefinition.Struct(_, fields):
                processStructFields(fields);
                
            case TypeDefinition.Tuple(_, arguments):
				processTupleElements(arguments);
		}
	}
    
	
	private function processEnumConstuctors(constructors:Array<EnumConstructor>):Void
	{
        // TODO: validation condition dupplication
        
    	var usedNames = new Set<String>(new Map());
        inline function add(name:EnumConstructorName):Void
        {
            if (usedNames.exists(name.name))
            {
                addError(IdlReadErrorKind.EnumConstuctorNameDupplicated(name));
            }
            else
            {
                usedNames.set(name.name);
            }
        }
        
        for (constructor in constructors)
		{
            switch (constructor)
            {
                case EnumConstructor.Primitive(name):
                    add(name);
                    
                case EnumConstructor.Parameterized(parameterized):
                    add(parameterized.name);
                    processTupleElements(parameterized.elements);
            }
        }
	}
	
    private function processStructFields(fields:Array<StructElement>):Void
    {
        // TODO: validation condition dupplication
        
    	var usedNames = new Set<String>(new Map());
        inline function add(name:StructFieldName):Void
        {
            if (usedNames.exists(name.name))
            {
                addError(IdlReadErrorKind.StructFieldNameDupplicated(name));
            }
            else
            {
                usedNames.set(name.name);
            }
        }
        
        for (field in fields)
        {
            switch (field)
            {
                case StructElement.Label(name):
                    add(name);
                    // TODO: validation kind
                    
                case StructElement.Field(field):
                    add(field.name);
                    processTypeReference(field.type);
                    
                    // TODO: validation default value
            }
        }
    }
    
	private function processTupleElements(arguments:Array<TupleElement>):Void
	{
        // TODO: validation condition dupplication
        
		var usedNames = new Set<String>(new Map());
		for (argument in arguments)
		{
            switch (argument)
            {
                case TupleElement.Label(_):
                    // Nothing to do.
                
                case TupleElement.Data(argument):
                    if (usedNames.exists(argument.name.name))
                    {
                        addError(IdlReadErrorKind.ArgumentNameDupplicated(argument.name));
                    }
                    else
                    {
                        usedNames.set(argument.name.name);
                        processTypeReference(argument.type);
                    }
                    
                    // TODO: validation default value
            }
		}
	}
    
	private function processTypeReference(type:TypeReference):Void
	{
		var path, parameters;
		switch (type)
		{
			case TypeReference.Primitive(p):
				path = p;
				parameters = [];
				
			case TypeReference.Generic(genericType):
				path = genericType.typePath;
				parameters = genericType.parameters;
		}
		
		switch (path.modulePath.toOption())
		{
			case Option.Some(modulePath):
				switch (parent.element.root.getElement(modulePath.toArray()).toOption())
				{
					case Option.Some(referredElement):
						switch (referredElement.getType(path.typeName).toOption())
						{
							case Option.Some(type):
								processTypeReferenceParameters(path, type.getTypeParameters(), parameters);
								
							case Option.None:
								addError(IdlReadErrorKind.TypeNotFound(path));
						}
						
					case Option.None:
						addError(IdlReadErrorKind.ModuleNotFound(modulePath));
				}
				
			case Option.None:
				if (path.typeName.toString() == "Array")
				{
					processTypeReferenceParameters(
						path, 
						[TypeParameterDeclaration.TypeName(new TypeName(new LitllString("T")))], 
						parameters
					);
					return;
				}
                
				if (path.isCoreType() || typeParameters.exists(path.typeName.toString())) 
				{
					if (parameters.length != 0)
					{
						addError(IdlReadErrorKind.InvalidTypeParameterLength(path, 0, parameters.length));
					}
					return;
				}
				
				for (importedElement in parent.importedElements)
				{
					switch (importedElement.getType(path.typeName).toOption())
					{
						case Option.Some(type):
							var module = importedElement.getModulePath();
							path.modulePath = Maybe.some(module);
							processTypeReferenceParameters(path, type.getTypeParameters(), parameters);
							break;
							
						case Option.None:
					}
				}
				
				if (path.modulePath.isNone())
				{
					addError(IdlReadErrorKind.TypeNotFound(path));
				}
		}
	}
	
	private function processTypeReferenceParameters(path:TypePath, definitionParameters:Array<TypeParameterDeclaration>, referenceParameters:Array<TypeReferenceParameter>):Void 
	{
		if (referenceParameters.length != definitionParameters.length)
		{
			addError(
				IdlReadErrorKind.InvalidTypeParameterLength(
					path, definitionParameters.length, referenceParameters.length
				)
			);
		}
		
		var iter = referenceParameters.iterator();
		for (definitionParameter in definitionParameters)
		{
			var referenceParameter = iter.next();
			var processedValue = switch (definitionParameter)
			{
				case TypeParameterDeclaration.Dependence(dependence):
					TypeReferenceParameterKind.Dependence(dependence.type);
					
				case TypeParameterDeclaration.TypeName(_):
					var context = new DelitllfyContext(referenceParameter.value, parent.element.root.reader.config);
					switch (TypeReferenceDelitllfier.process(context))
					{
						case Result.Ok(reference):
							processTypeReference(reference);
							TypeReferenceParameterKind.Type(reference);
							
						case Result.Err(err):
							addError(IdlReadErrorKind.Delitll(err));
							return;
					}
			}
			
			referenceParameter.processedValue = Maybe.some(processedValue);
		}
	}
	
	private function addError(kind:IdlReadErrorKind):Void 
	{
		parent.addError(kind);
	}
}

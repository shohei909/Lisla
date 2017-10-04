package arraytree.idl.generator.source.resolve;

import haxe.ds.Option;
import hxext.ds.Maybe;
import hxext.ds.Result;
import arraytree.data.meta.core.StringWithMetadata;
import arraytree.idl.generator.error.TypeDefinitionResolutionErrorKind;
import arraytree.idl.generator.source.resolve.IdlResolver;
import arraytree.idl.arraytree2entity.ArrayTreeToEntityContext;
import arraytree.idl.arraytreetext2entity.error.ArrayTreeTextToEntityErrorKind;
import arraytree.idl.std.entity.idl.TypeDefinition;
import arraytree.idl.std.entity.idl.TypeDependenceName;
import arraytree.idl.std.entity.idl.TypeName;
import arraytree.idl.std.entity.idl.TypeParameterDeclaration;
import arraytree.idl.std.entity.idl.TypePath;
import arraytree.idl.std.entity.idl.TypeReference;
import arraytree.idl.std.entity.idl.TypeReferenceDependenceKind;
import arraytree.idl.std.entity.idl.TypeReferenceParameter;
import arraytree.idl.std.entity.idl.TypeReferenceParameterKind;
import arraytree.idl.std.arraytree2entity.idl.TypeReferenceArrayTreeToEntity;

class TypeDefinitionResolver
{
	private var parent:IdlResolver;
	private var definition:TypeDefinition;
	private var typeParameters:Map<String, TypeName>;
    
	public static function run(parent:IdlResolver, definition:TypeDefinition):Void
	{
		var runner = new TypeDefinitionResolver(parent, definition);
		runner.collectTypeParameters();
		runner.process();
	}
	
	private function new(parent:IdlResolver, definition:TypeDefinition)
	{
		this.parent = parent;
		this.definition = definition;
		this.typeParameters = new Map<String, TypeName>();
    }
	
	private function collectTypeParameters():Void
	{
		var typeDependences = new Map<String, TypeDependenceName>();
		for (typeParameter in definition.getTypeParameters())
		{
			switch (typeParameter)
			{
				case TypeParameterDeclaration.TypeName(typeName):
                    if (typeParameters.exists(typeName.toString()))
					{
						addError(LoadIdlErrorKind.TypeParameterNameDuplicated(typeName));
					}
					else
					{
						typeParameters.set(typeName.toString(), typeName);
					}
					
				case TypeParameterDeclaration.Dependence(dependence):
                    // nothing to do
			}
		}
	}
	
	private function process():Void
	{
        TypeDefinitionTools.iterateOverTypeReference(definition, processTypeReference);
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
                switch (parent.library.resolveModuleElement(modulePath))
                {
                    case Result.Ok():
                        
                    case Result.Error():
                }
                
				switch (targetLibrary.getModuleElement(modulePath).toOption())
				{
					case Option.Some(referredElement):
						switch (referredElement.getTypeDefinition(parent.context, path.typeName).toOption())
						{
							case Option.Some(type):
								processTypeReferenceParameters(path, type.getTypeParameters(), parameters);
								
							case Option.None:
								addError(LoadIdlErrorKind.TypeNotFound(path));
						}
						
					case Option.None:
						addError(LoadIdlErrorKind.ModuleNotFound(modulePath));
				}
				
			case Option.None:
                if (path.typeName.toString() == "Array")
				{
					processTypeReferenceParameters(
						path, 
						[TypeParameterDeclaration.TypeName(new TypeName(new StringWithMetadata("T")))], 
						parameters
					);
					return;
				}
                
				if (path.isCoreType() || typeParameters.exists(path.typeName.toString())) 
				{
					if (parameters.length != 0)
					{
                        
                        addError(
                            TypeDefinitionResolutionErrorKind.Validation(
                                IdlValidationErrorKindTools.createInvalidTypeParameterLength(path, 0, parameters.length)
                            )
                        );
					}
					return;
				}
				
                for (importedElement in parent.importedElements)
				{
					switch (importedElement.getTypeDefinition(parent.context, path.typeName).toOption())
					{
						case Option.Some(type):
							var module = importedElement.path.toModulePath();
							path.modulePath = Maybe.some(module);
					        processTypeReferenceParameters(path, type.getTypeParameters(), parameters);
                            break;
							
						case Option.None:
					}
				}
				
				if (path.modulePath.isNone())
				{
					addError(TypeDefinitionResolutionErrorKind.TypeNotFound(path));
				}
		}
	}
	
	private function processTypeReferenceParameters(path:TypePath, definitionParameters:Array<TypeParameterDeclaration>, referenceParameters:Array<TypeReferenceParameter>):Void 
	{
		if (referenceParameters.length != definitionParameters.length)
		{
			addError(
				TypeDefinitionResolutionErrorKind.Validation(
                    IdlValidationErrorKindTools.createInvalidTypeParameterLength(path, definitionParameters.length, referenceParameters.length)
				)
			);
            return;
		}
		
		var iter = referenceParameters.iterator();
		for (definitionParameter in definitionParameters)
		{
			var referenceParameter = iter.next();
			var processedValue = switch (definitionParameter)
			{
				case TypeParameterDeclaration.Dependence(dependence):
                    var data = switch (referenceParameter.value)
                    {
                        case AlTreeKind.Arr(data) if (data.length == 2 && data.data[0].match(AlTreeKind.Leaf(_ => "const"))):
                            TypeReferenceDependenceKind.Const(data.data[1]);
                            
                        case AlTreeKind.Arr(data) if (data.length == 2 && data.data[0].match(AlTreeKind.Leaf(_ => "ref"))):
                            switch (data.data[1])
                            {
                                case AlTreeKind.Leaf(name):
                                    TypeReferenceDependenceKind.Reference(name.data);
                                    
                                case _:
                                    addError(TypeDefinitionResolutionErrorKind.InvalidTypeDependenceDescription(referenceParameter.value));
                                    continue;
                            }
                            
                        case _:
                            addError(
                                TypeDefinitionResolutionErrorKind.InvalidTypeDependenceDescription(referenceParameter.value)
                            );
                            continue;
                    }
                    
                    TypeReferenceParameterKind.Dependence(data, dependence.type);
					
				case TypeParameterDeclaration.TypeName(_):
					var arraytreeToEntityContext = new ArrayTreeToEntityContext(referenceParameter.value, parent.context.config);
					switch (TypeReferenceArrayTreeToEntity.process(arraytreeToEntityContext))
					{
						case Result.Ok(reference):
							processTypeReference(reference);
							TypeReferenceParameterKind.Type(reference);
							
						case Result.Error(error):
							addError(
                                TypeDefinitionResolutionErrorKind.TypeReferenceToEntity(error)
                            );
							continue;
					}
			}
			
			referenceParameter.processedValue = Maybe.some(processedValue);
		}
	}
	
	private function addError(
        kind:TypeDefinitionResolutionErrorKind
    ):Void 
	{
		parent.addError(kind);
	}
}

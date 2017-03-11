package litll.idl.generator.source.resolve;

import haxe.ds.Option;
import hxext.ds.Maybe;
import hxext.ds.Result;
import litll.core.Litll;
import litll.core.LitllString;
import litll.idl.generator.error.IdlValidationErrorKindTools;
import litll.idl.generator.error.LoadIdlErrorKind;
import litll.idl.generator.source.resolve.IdlResolver;
import litll.idl.litll2entity.LitllToEntityContext;
import litll.idl.litlltext2entity.error.LitllTextToEntityErrorKind;
import litll.idl.std.entity.idl.TypeDefinition;
import litll.idl.std.entity.idl.TypeDependenceName;
import litll.idl.std.entity.idl.TypeName;
import litll.idl.std.entity.idl.TypeParameterDeclaration;
import litll.idl.std.entity.idl.TypePath;
import litll.idl.std.entity.idl.TypeReference;
import litll.idl.std.entity.idl.TypeReferenceDependenceKind;
import litll.idl.std.entity.idl.TypeReferenceParameter;
import litll.idl.std.entity.idl.TypeReferenceParameterKind;
import litll.idl.std.litll2entity.idl.TypeReferenceLitllToEntity;
using litll.idl.std.tools.idl.TypeDefinitionTools;

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
                var targetLibrary = switch (parent.library.getReferencedLibrary(parent.file, modulePath.libraryName))
                {
                    case Result.Ok(_library):
                        _library;
                        
                    case Result.Err(errors):
                        parent.addErrors(errors);
                        return;
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
						[TypeParameterDeclaration.TypeName(new TypeName(new LitllString("T")))], 
						parameters
					);
					return;
				}
                
				if (path.isCoreType() || typeParameters.exists(path.typeName.toString())) 
				{
					if (parameters.length != 0)
					{
                        
                        addError(
                            LoadIdlErrorKind.Validation(
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
					addError(LoadIdlErrorKind.TypeNotFound(path));
				}
		}
	}
	
	private function processTypeReferenceParameters(path:TypePath, definitionParameters:Array<TypeParameterDeclaration>, referenceParameters:Array<TypeReferenceParameter>):Void 
	{
		if (referenceParameters.length != definitionParameters.length)
		{
			addError(
				LoadIdlErrorKind.Validation(
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
                        case Litll.Arr(data) if (data.length == 2 && data.data[0].match(Litll.Str(_.data => "const"))):
                            TypeReferenceDependenceKind.Const(data.data[1]);
                            
                        case Litll.Arr(data) if (data.length == 2 && data.data[0].match(Litll.Str(_.data => "ref"))):
                            switch (data.data[1])
                            {
                                case Litll.Str(name):
                                    TypeReferenceDependenceKind.Reference(name.data);
                                    
                                case _:
                                    addError(LoadIdlErrorKind.InvalidTypeDependenceDescription(referenceParameter.value));
                                    continue;
                            }
                            
                        case _:
                            addError(LoadIdlErrorKind.InvalidTypeDependenceDescription(referenceParameter.value));
                            continue;
                    }
                    
                    TypeReferenceParameterKind.Dependence(data, dependence.type);
					
				case TypeParameterDeclaration.TypeName(_):
					var litllToEntityContext = new LitllToEntityContext(referenceParameter.value, parent.context.config);
					switch (TypeReferenceLitllToEntity.process(litllToEntityContext))
					{
						case Result.Ok(reference):
							processTypeReference(reference);
							TypeReferenceParameterKind.Type(reference);
							
						case Result.Err(err):
							addError(LoadIdlErrorKind.LitllTextToEntity(LitllTextToEntityErrorKind.LitllToEntity(err)));
							continue;
					}
			}
			
			referenceParameter.processedValue = Maybe.some(processedValue);
		}
	}
	
	private function addError(kind:LoadIdlErrorKind):Void 
	{
		parent.addErrorKind(kind);
	}
}

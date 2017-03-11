package litll.idl.generator.source.preprocess;

import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllString;
import hxext.ds.Maybe;
import hxext.ds.Result;
import hxext.ds.Set;
import litll.idl.litll2entity.LitllToEntityContext;
import litll.idl.generator.error.ReadIdlErrorKind;
import litll.idl.generator.error.IdlValidationErrorKind;
import litll.idl.generator.error.IdlValidationErrorKindTools;
import litll.idl.generator.source.preprocess.IdlPreprocessor;
import litll.idl.litlltext2entity.error.LitllTextToEntityErrorKind;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.data.idl.StructElementName;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypeDependenceName;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeNameDeclaration;
import litll.idl.std.data.idl.TypeParameterDeclaration;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.TypeReferenceDependenceKind;
import litll.idl.std.data.idl.TypeReferenceParameter;
import litll.idl.std.data.idl.TypeReferenceParameterKind;
import litll.idl.std.litll2entity.idl.TypeReferenceLitllToEntity;
import litll.idl.std.error.GetConditionErrorKind;
import litll.idl.std.error.TypeFollowErrorKind;
using litll.idl.std.tools.idl.TypeDefinitionTools;

class TypeDefinitionPreprocessor
{
	private var parent:IdlPreprocessor;
	private var definition:TypeDefinition;
	private var typeParameters:Map<String, TypeName>;
    
	public static function run(parent:IdlPreprocessor, definition:TypeDefinition):Void
	{
		var runner = new TypeDefinitionPreprocessor(parent, definition);
		runner.collectTypeParameters();
		runner.process();
	}
	
	private function new(parent:IdlPreprocessor, definition:TypeDefinition)
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
						addError(ReadIdlErrorKind.TypeParameterNameDuplicated(typeName));
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
								addError(ReadIdlErrorKind.TypeNotFound(path));
						}
						
					case Option.None:
						addError(ReadIdlErrorKind.ModuleNotFound(modulePath));
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
                            ReadIdlErrorKind.Validation(
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
					addError(ReadIdlErrorKind.TypeNotFound(path));
				}
		}
	}
	
	private function processTypeReferenceParameters(path:TypePath, definitionParameters:Array<TypeParameterDeclaration>, referenceParameters:Array<TypeReferenceParameter>):Void 
	{
		if (referenceParameters.length != definitionParameters.length)
		{
			addError(
				ReadIdlErrorKind.Validation(
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
                                    addError(ReadIdlErrorKind.InvalidTypeDependenceDescription(referenceParameter.value));
                                    continue;
                            }
                            
                        case _:
                            addError(ReadIdlErrorKind.InvalidTypeDependenceDescription(referenceParameter.value));
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
							addError(ReadIdlErrorKind.LitllTextToEntity(LitllTextToEntityErrorKind.LitllToEntity(err)));
							continue;
					}
			}
			
			referenceParameter.processedValue = Maybe.some(processedValue);
		}
	}
	
	private function addError(kind:ReadIdlErrorKind):Void 
	{
		parent.addErrorKind(kind);
	}
}

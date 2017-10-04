package lisla.idl.std.tools.idl;
import haxe.ds.Option;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.TypeParam;
import lisla.data.meta.core.tag;
import lisla.data.meta.core.StringWithtag;
import hxext.ds.Result;
import lisla.idl.exception.IdlException;
import lisla.idl.generator.data.EntityOutputConfig;
import lisla.idl.generator.output.entity.EntityHaxeTypePath;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityCaseCondition;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityGuardConditionKind;
import lisla.idl.generator.source.IdlSourceProvider;
import lisla.idl.std.entity.idl.FollowedTypeDefinition;
import lisla.idl.std.entity.idl.GenericTypeReference;
import lisla.idl.std.entity.idl.ModulePath;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.entity.idl.TypePath;
import lisla.idl.std.entity.idl.TypeReference;
import lisla.idl.std.entity.idl.TypeReferenceDependenceKind;
import lisla.idl.std.entity.idl.TypeReferenceParameterKind;
import lisla.idl.std.error.GetConditionError;
import lisla.idl.std.error.GetConditionErrorKind;
import lisla.idl.std.error.TypeFollowErrorKind;
import lisla.idl.std.error.TypeFollowError;

using lisla.idl.std.tools.idl.TypeDefinitionTools;
using lisla.idl.std.tools.idl.TypeParameterDeclarationTools;
using lisla.idl.std.tools.idl.TupleElementTools;
using lisla.idl.std.tools.idl.ArgumentTools;
using lisla.idl.std.tools.idl.EnumConstructorTools;
using lisla.idl.std.tools.idl.TypeReferenceParameterTools;
using lisla.idl.std.tools.idl.TypeReferenceTools;
using lisla.idl.std.tools.idl.StructElementTools;
using hxext.ds.ResultTools;

class TypeReferenceTools
{
	public static function toMacroTypePath(reference:TypeReference, config:EntityOutputConfig):haxe.macro.Expr.TypePath
	{
		inline function toHaxeDataPath(typePath:TypePath):EntityHaxeTypePath
		{
			return config.toHaxePath(typePath);
		}
		
		return switch (reference)
		{
			case TypeReference.Primitive(typePath):
				toHaxeDataPath(typePath).toMacroPath();
				
			case TypeReference.Generic(generic):
				var result = toHaxeDataPath(generic.typePath).toMacroPath();
				
				for (parameter in generic.parameters)
				{
					switch (parameter.processedValue.getOrThrow(IdlException.new.bind("Type reference " + generic.typePath.toString() + " must be processed")))
					{
						case TypeReferenceParameterKind.Type(type):
							result.params.push(TypeParam.TPType(ComplexType.TPath(toMacroTypePath(type, config))));
						
						case TypeReferenceParameterKind.Dependence(_):
					}
				}
				
				result;
		}
	}
    
	public static function getTypePath(type:TypeReference):TypePath
    {
		return switch (type)
		{
			case TypeReference.Primitive(primitive):
				primitive;
				
			case TypeReference.Generic(generic):
    			generic.typePath;
		}
    }
    
	public static function generalize(type:TypeReference):GenericTypeReference
	{
		return switch (type)
		{
			case TypeReference.Primitive(primitive):
				new GenericTypeReference(primitive, []);
				
			case TypeReference.Generic(generic):
    			generic;
		}
	}
    
    public static function getTypeReferenceName(type:TypeReference):String
    {
		return switch (type)
		{
			case TypeReference.Primitive(primitive):
				primitive.toString();
				
			case TypeReference.Generic(generic):
    			generic.typePath.toString();
		}
    }
    
    public static function followOrThrow(type:TypeReference, source:IdlSourceProvider, definitionParameters:Array<TypeName>):FollowedTypeDefinition
    {
        return follow(type, source, definitionParameters).getOrThrow(TypeFollowError.toIdlException);
    }
    
    public static function follow(type:TypeReference, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<FollowedTypeDefinition, TypeFollowError>
    {
        var startPath = getTypePath(type).toString();
        return _follow(type, [startPath], source, definitionParameters);
    }
    
    public static function _follow(type:TypeReference, history:Array<String>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<FollowedTypeDefinition, TypeFollowError>
    {
        var parameterNames = [for (p in definitionParameters) p.toString()];
        var generic = generalize(type);
        var referenceParameters = generic.parameters.getTypeParameters();
        var targetPath = generic.typePath;
        
        var name = targetPath.toString();
        if (name == "String")
        {
            return if (generic.parameters.length == 0)
            {
                Result.Ok(FollowedTypeDefinition.Str);
            }
            else
            {
                Result.Error(
                    new TypeFollowError(TypeFollowErrorKind.InvalidTypeParameterLength(targetPath, 0, generic.parameters.length))
                );
            }
        }
        if (name == "Array")
        {
            return if (generic.parameters.length == 1)
            {
                if (referenceParameters.length == 1)
                {
                    Result.Ok(FollowedTypeDefinition.Arr(referenceParameters[0]));
                }
                else
                {
                    throw new IdlException("invalid TypeReferenceParameterKind");
                }
            }
            else
            {
                Result.Error(
                    new TypeFollowError(TypeFollowErrorKind.InvalidTypeParameterLength(targetPath, 1, generic.parameters.length))
                );
            }
        }
        if (parameterNames.indexOf(name) != -1)
        {
            // Any
            targetPath = new TypePath(
                new ModulePath(["lisla", "core"], new tag()), 
                new TypeName(new StringWithtag("Any", new tag())),
                new tag()
            );
        }
        
        return switch (source.resolveTypePath(targetPath).toOption())
        {
            case Option.Some(definition):
                TypeDefinitionTools.follow(definition, history, source, generic.parameters, definitionParameters);
                
            case Option.None:
                throw new IdlException("Type " + generic.typePath.toString() + " not found.");
        }
    }
    
    public static function mapOverTypePath(type:TypeReference, func:TypePath->TypePath):TypeReference
    {
        return switch (type)
        {
            case TypeReference.Primitive(typePath):
                TypeReference.Primitive(func(typePath));
                
            case TypeReference.Generic(generic):
                TypeReference.Generic(
                    new GenericTypeReference(
                        func(generic.typePath), 
                        [
                            for (parameter in generic.parameters)
                            {
                                TypeReferenceParameterTools.mapOverTypePath(parameter, func);
                            }
                        ]
                    )
                );
        }
    }
    
    public static function specialize(type:TypeReference, typeMap:Map<String, TypeReference>, dependenceMap:Map<String, TypeReferenceDependenceKind>):TypeReference
    {
        return switch (type)
        {
            case TypeReference.Primitive(typePath):
                var name = typePath.toString();
                if (typeMap.exists(name)) typeMap[name] else type;
                
            case TypeReference.Generic(generic):
                TypeReference.Generic(
                    new GenericTypeReference(
                        generic.typePath, 
                        [
                            for (parameter in generic.parameters)
                            {
                                TypeReferenceParameterTools.specialize(parameter, typeMap, dependenceMap);
                            }
                        ]
                    )
                );
        }
    }
    
    public static function getGuardConditionKind(
        type:TypeReference, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>
    ):Result<LislaToEntityGuardConditionKind, GetConditionError>
    {
        return switch (type.follow(source, definitionParameters))
        {
            case Result.Ok(data):
                switch (data)
                {
                    case FollowedTypeDefinition.Str:
                        Result.Ok(LislaToEntityGuardConditionKind.Str);
                        
                    case FollowedTypeDefinition.Struct(_)
                        | FollowedTypeDefinition.Arr(_)
                        | FollowedTypeDefinition.Tuple(_):
                        Result.Ok(LislaToEntityGuardConditionKind.Arr);
                        
                    case FollowedTypeDefinition.Enum(constructors):
                        constructors.getGuardConditionKind(source, definitionParameters);
                }
                
            case Result.Error(error):
                Result.Error(
                    new GetConditionError(GetConditionErrorKind.Follow(error))
                );
        }
    }
    
    public static function getConditions(
        type:TypeReference, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>
    ):Result<Array<LislaToEntityCaseCondition>, GetConditionError>
    {
        return switch (type.follow(source, definitionParameters))
        {
            case Result.Ok(type):
                FollowedTypeDefinitionTools.getConditions(type, source, definitionParameters);
                
            case Result.Error(error):
                Result.Error(
                    new GetConditionError(GetConditionErrorKind.Follow(error))
                );
        }
    }
}

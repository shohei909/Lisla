package litll.idl.std.tools.idl;
import haxe.ds.Option;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.TypeParam;
import litll.core.LitllString;
import litll.core.ds.Result;
import litll.idl.exception.IdlException;
import litll.idl.generator.data.DataOutputConfig;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.generator.output.delitll.match.DelitllfyCaseCondition;
import litll.idl.generator.output.delitll.match.DelitllfyGuardConditionKind;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.FollowedTypeDefinition;
import litll.idl.std.data.idl.GenericTypeReference;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.TypeReferenceDependenceKind;
import litll.idl.std.data.idl.TypeReferenceParameterKind;
import litll.idl.std.error.GetConditionErrorKind;
import litll.idl.std.error.TypeFollowErrorKind;
import litll.idl.std.error.TypeFollowErrorKindTools;

using litll.idl.std.tools.idl.TypeDefinitionTools;
using litll.idl.std.tools.idl.TypeParameterDeclarationTools;
using litll.idl.std.tools.idl.TupleElementTools;
using litll.idl.std.tools.idl.ArgumentTools;
using litll.idl.std.tools.idl.EnumConstructorTools;
using litll.idl.std.tools.idl.TypeReferenceParameterTools;
using litll.idl.std.tools.idl.TypeReferenceTools;
using litll.idl.std.tools.idl.StructElementTools;
using litll.core.ds.ResultTools;

class TypeReferenceTools
{
	public static function toMacroTypePath(reference:TypeReference, config:DataOutputConfig):haxe.macro.Expr.TypePath
	{
		inline function toHaxeDataPath(typePath:TypePath):HaxeDataTypePath
		{
			return config.toHaxeDataPath(typePath);
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
        return follow(type, source, definitionParameters).getOrThrow(TypeFollowErrorKindTools.toIdlException);
    }
    
    public static function follow(type:TypeReference, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<FollowedTypeDefinition, TypeFollowErrorKind>
    {
        var startPath = getTypePath(type).toString();
        return _follow(type, [startPath], source, definitionParameters);
    }
    
    public static function _follow(type:TypeReference, history:Array<String>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<FollowedTypeDefinition, TypeFollowErrorKind>
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
                Result.Err(TypeFollowErrorKind.InvalidTypeParameterLength(targetPath, 0, generic.parameters.length));
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
                Result.Err(TypeFollowErrorKind.InvalidTypeParameterLength(targetPath, 1, generic.parameters.length));
            }
        }
        if (parameterNames.indexOf(name) != -1)
        {
            // Any
            targetPath = new TypePath(new ModulePath(["litll", "core"]), new TypeName(new LitllString("Any")));
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
    
    public static function getGuardConditionKind(type:TypeReference, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<DelitllfyGuardConditionKind, GetConditionErrorKind>
    {
        return switch (type.follow(source, definitionParameters))
        {
            case Result.Ok(data):
                switch (data)
                {
                    case FollowedTypeDefinition.Str:
                        Result.Ok(DelitllfyGuardConditionKind.Str);
                        
                    case FollowedTypeDefinition.Struct(_)
                        | FollowedTypeDefinition.Arr(_)
                        | FollowedTypeDefinition.Tuple(_):
                        Result.Ok(DelitllfyGuardConditionKind.Arr);
                        
                    case FollowedTypeDefinition.Enum(constructors):
                        constructors.getGuardConditionKind(source, definitionParameters);
                }
                
            case Result.Err(error):
                Result.Err(GetConditionErrorKind.Follow(error));
        }
    }
    
    public static function getConditions(type:TypeReference, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<Array<DelitllfyCaseCondition>, GetConditionErrorKind>
    {
        return switch (type.follow(source, definitionParameters))
        {
            case Result.Ok(type):
                FollowedTypeDefinitionTools.getConditions(type, source, definitionParameters);
                
            case Result.Err(error):
                Result.Err(GetConditionErrorKind.Follow(error));
        }
    }
}

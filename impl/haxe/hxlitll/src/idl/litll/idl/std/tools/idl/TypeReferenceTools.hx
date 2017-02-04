package litll.idl.std.tools.idl;
import haxe.ds.Option;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.TypeParam;
import litll.core.LitllString;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.idl.exception.IdlException;
import litll.idl.generator.data.DataOutputConfig;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.FollowedTypeDefinition;
import litll.idl.std.data.idl.GenericTypeReference;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.data.idl.SpecializedTypeDefinition;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.TypeReferenceDependenceKind;
import litll.idl.std.data.idl.TypeReferenceParameter;
import litll.idl.std.data.idl.TypeReferenceParameterKind;
import litll.idl.std.tools.idl.error.TypeSpecializeErrorKindTools;

using litll.idl.std.tools.idl.TypeDefinitionTools;
using litll.idl.std.tools.idl.TypeParameterDeclarationTools;
using litll.idl.std.tools.idl.TupleElementTools;
using litll.idl.std.tools.idl.ArgumentTools;
using litll.idl.std.tools.idl.EnumConstructorTools;
using litll.idl.std.tools.idl.TypeReferenceParameterTools;
using litll.idl.std.tools.idl.TypeReferenceTools;
using litll.idl.std.tools.idl.StructElementTools;

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
    
    public static function follow(specializedType:TypeReference, source:IdlSourceProvider, parentDefinitionParameters:Array<TypeName>):FollowedTypeDefinition
    {
        var parameterNames = [for (p in parentDefinitionParameters) p.toString()];
        var generic = generalize(specializedType);
        var referenceParameters = generic.parameters.getTypeParameters();
        var targetPath = generic.typePath;
        
        switch (specializedType)
        {
            case TypeReference.Primitive(typePath):
                var name = typePath.toString();
                if (parameterNames.indexOf(name) != -1)
                {
                    // Any
                    targetPath = new TypePath(new ModulePath(["litll", "core"]), new TypeName(new LitllString("Any")));
                }
                if (name == "String")
                {
                    return FollowedTypeDefinition.Str;
                }
            
            case TypeReference.Generic(generic):
                var name = generic.typePath.toString();
                if (name == "Array" && generic.parameters.length == 1)
                {
                    switch (generic.parameters[0].processedValue.toOption())
                    {
                        case Option.Some(TypeReferenceParameterKind.Type(_)):
                            return FollowedTypeDefinition.Arr(referenceParameters[0]);
                            
                        case _:
                    }
                }
                
            case _:
        }
        
        return switch (source.resolveTypePath(targetPath).toOption())
        {
            case Option.Some(validType):
                switch(TypeDefinitionTools.specialize(validType.definition, generic.parameters))
                {
                    case Result.Ok(specializedTypeDefinition):
                        switch (specializedTypeDefinition)
                        {
                            case SpecializedTypeDefinition.Enum(constuctors):
                                FollowedTypeDefinition.Enum(constuctors);
                                
                            case SpecializedTypeDefinition.Tuple(arguments):
                                FollowedTypeDefinition.Tuple(arguments);
                                
                            case SpecializedTypeDefinition.Struct(fields):
                                FollowedTypeDefinition.Struct(fields);
                                
                            case SpecializedTypeDefinition.Newtype(type):
                                follow(type, source, parentDefinitionParameters);
                        }
                        
                    case Result.Err(error):
                        throw new IdlException(TypeSpecializeErrorKindTools.toString(error));
                }
                
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
                                var processedValue = switch (parameter.processedValue.toOption())
                                {
                                    case Option.None:
                                        Maybe.none();
                                        
                                    case Option.Some(TypeReferenceParameterKind.Type(type)):
                                        var kind = TypeReferenceParameterKind.Type(specialize(type, typeMap, dependenceMap));
                                        Maybe.some(kind);
                                        
                                    case Option.Some(TypeReferenceParameterKind.Dependence(data, type)):
                                        var kind = TypeReferenceParameterKind.Dependence(
                                            switch (data)
                                            {
                                                case TypeReferenceDependenceKind.Reference(name):
                                                    if (dependenceMap.exists(name)) dependenceMap[name] else data; 
                                                    
                                                case TypeReferenceDependenceKind.Const(value):
                                                    data;
                                            },
                                            specialize(type, typeMap, dependenceMap)
                                        );
                                        Maybe.some(kind);
                                }
                                
                                var result = new TypeReferenceParameter(parameter.value);
                                result.processedValue = processedValue;
                                result;
                            }
                        ]
                    )
                );
        }
    }
}

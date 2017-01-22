package litll.idl.std.tools.idl;
import haxe.ds.Option;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.TypeParam;
import litll.core.LitllString;
import litll.idl.exception.IdlException;
import litll.idl.project.output.IdlToHaxeConvertContext;
import litll.idl.project.output.data.HaxeDataTypePath;
import litll.idl.project.output.data.store.HaxeDataInterfaceStore;
import litll.idl.project.source.IdlSourceProvider;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.GenericTypeReference;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.data.idl.ParameterizedEnumConstructor;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeParameterDeclaration;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.TypeReferenceParameter;
import litll.idl.std.data.idl.TypeReferenceParameterKind;
import litll.idl.std.data.idl.UnfoldedTypeDefinition;
import litll.idl.std.data.idl.haxe.DataOutputConfig;
import litll.idl.std.data.idl.TypeDefinition;

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
    
    public static function unfold(type:TypeReference, source:IdlSourceProvider, parentDefinitionParameters:Array<TypeName>):UnfoldedTypeDefinition
    {
        var parameterNames = [for (p in parentDefinitionParameters) p.toString()];
        var generic = generalize(type);
        var referenceParameters = generic.parameters.getTypeParameters();
        var targetPath = generic.typePath;
        switch (type)
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
                    return UnfoldedTypeDefinition.Str;
                }
            
            case TypeReference.Generic(generic):
                var name = generic.typePath.toString();
                if (name == "Array" && generic.parameters.length == 1)
                {
                    switch (generic.parameters[0].processedValue.toOption())
                    {
                        case Option.Some(TypeReferenceParameterKind.Type(_)):
                            return UnfoldedTypeDefinition.Arr(referenceParameters[0]);
                            
                        case _:
                    }
                }
                
            case _:
        }
        
        return switch (source.resolveTypePath(targetPath).toOption())
        {
            case Option.Some(definition):
                
                var parameterContext = new Map<String, TypeReference>();
                var definitionParameters = definition.getTypeParameters().collect().parameters;
                if (referenceParameters.length != definitionParameters.length)
                {
                    throw new IdlException("invalid type parameter length.");
                }
                for (i in 0...definitionParameters.length)
                {
                    var referenceParameter:TypeReference = referenceParameters[i];
                    var definitionParameter:TypeName = definitionParameters[i];
                    
                    parameterContext[definitionParameter.toString()] = referenceParameter;
                }
                switch (definition)
                {
                    case TypeDefinition.Enum(_, constuctors):
                        UnfoldedTypeDefinition.Enum(
                            [for (el in constuctors) el.resolveGenericType(parameterContext)]
                        );
                        
                    case TypeDefinition.Tuple(_, arguments):
                        UnfoldedTypeDefinition.Tuple(
                            [for (el in arguments) el.resolveGenericType(parameterContext)]
                        );
                        
                    case TypeDefinition.Struct(_, fields):
                        UnfoldedTypeDefinition.Struct(
                            [for (el in fields) el.resolveGenericType(parameterContext)]
                        );
                        
                    case TypeDefinition.Newtype(_, type):
                        unfold(resolveGenericType(type, parameterContext), source, []);
                }
                
            case Option.None:
                throw new IdlException(generic.typePath.toString() + " can't be resolve.");
        }
    }
    
    
    public static function resolveGenericType(type:TypeReference, parameterContext:Map<String, TypeReference>):TypeReference
    {
        return switch (type)
        {
            case TypeReference.Primitive(typePath):
                if (parameterContext.exists(typePath.toString()))
                {
                    parameterContext[typePath.toString()];
                }
                else
                {
                    type;
                }
                
            case TypeReference.Generic(generic):
                TypeReference.Generic(
                    new GenericTypeReference(
                        generic.typePath, 
                        [
                            for (parameter in generic.parameters) TypeReferenceParameterTools.resolveGenericType(parameter, parameterContext)
                        ]
                    )
                );
        }
    }
}

package litll.idl.std.tools.idl;
import haxe.ds.Option;
import litll.core.ds.Result;
import litll.core.print.Printer;
import litll.idl.exception.IdlException;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.FollowedTypeDefinition;
import litll.idl.std.data.idl.SpecializedTypeDefinition;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeNameDeclaration;
import litll.idl.std.data.idl.TypeParameterDeclaration;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.TypeReferenceDependenceKind;
import litll.idl.std.data.idl.TypeReferenceParameter;
import litll.idl.std.data.idl.TypeReferenceParameterKind;
import litll.idl.std.tools.idl.error.TypeFollowErrorKind;
import litll.idl.std.tools.idl.error.TypeSpecializeErrorKind;
import litll.idl.std.tools.idl.error.TypeSpecializeErrorKindTools;

using litll.idl.std.tools.idl.TypeReferenceTools;
using litll.idl.std.data.idl.TypeParameterDeclaration;

class TypeDefinitionTools
{
	public static function getNameDeclaration(typeDefinition:TypeDefinition):TypeNameDeclaration
	{
		return switch (typeDefinition)
		{
			case 
				Struct(name, _) |
				Enum(name, _) |
				Newtype(name, _) |
				Tuple(name, _):
					
				name;
		}
	}
	
	public static function getTypeName(typeDefinition:TypeDefinition):TypeName
	{
		return TypeNameDeclarationTools.getTypeName(getNameDeclaration(typeDefinition));
	}
	
	public static function getTypeParameters(typeDefinition:TypeDefinition):Array<TypeParameterDeclaration>
	{
		return TypeNameDeclarationTools.getParameters(getNameDeclaration(typeDefinition));
	}
    
    public static function iterateOverTypeReference(typeDefinition:TypeDefinition, func:TypeReference->Void):Void
    {
		TypeParameterDeclarationTools.iterateOverTypeReference(getTypeParameters(typeDefinition), func);
	   
		switch (typeDefinition)
		{
			case TypeDefinition.Newtype(_, type):
				func(type);
				
			case TypeDefinition.Enum(_, constructors):
				for (constructor in constructors)
                {
                    EnumConstructorTools.iterateOverTypeReference(constructor, func);
                }
				
			case TypeDefinition.Struct(_, elements):
                for (element in elements)
                {
                    StructElementTools.iterateOverTypeReference(element, func);
                }
                
            case TypeDefinition.Tuple(_, elements):
				for (element in elements)
                {
                    TupleElementTools.iterateOverTypeReference(element, func);
                }
		}
    }
    
    
    public static function specialize(typeDefinition:TypeDefinition, referenceParameters:Array<TypeReferenceParameter>):Result<SpecializedTypeDefinition, TypeSpecializeErrorKind>
    {
        var definitionParameters = getTypeParameters(typeDefinition);
        if (referenceParameters.length != definitionParameters.length)
        {
            var error = TypeSpecializeErrorKind.InvalidTypeParameterLength(definitionParameters.length, referenceParameters.length);
            return Result.Err(error);
        }
        
        var typeMap = new Map<String, TypeReference>();
        var dependenceMap = new Map<String, TypeReferenceDependenceKind>();
        
        for (i in 0...definitionParameters.length)
        {
            var referenceParameter = TypeReferenceParameterTools.specialize(referenceParameters[i], typeMap, dependenceMap);
            var definitionParameter = definitionParameters[i];
            
            switch [definitionParameter, referenceParameter.processedValue.toOption()]
            {
                case [_, Option.None]:
                    var value = Printer.printLitll(referenceParameter.value);
                    throw new IdlException("type parameter '" + value + "' must be processed");
                
                case [TypeParameterDeclaration.TypeName(typeName), Option.Some(TypeReferenceParameterKind.Type(type))]:
                    typeMap[typeName.toString()] = type;
                    
                case [TypeParameterDeclaration.Dependence(dependence), Option.Some(TypeReferenceParameterKind.Dependence(value, _))]:
                    dependenceMap[dependence.name.data.toString()] = value;
                    
                case [_, _]:
                    throw new IdlException("unmatched type parameter");
            }
        }
        
        return Result.Ok(new TypeSpecializer(typeDefinition, typeMap, dependenceMap).result);
    }
    
    public static function follow(definition:TypeDefinition, startPath:String, source:IdlSourceProvider, referenceParameters:Array<TypeReferenceParameter>, definitionParameters:Array<TypeName>):Result<FollowedTypeDefinition, TypeFollowErrorKind>
    {
        return switch(TypeDefinitionTools.specialize(definition, referenceParameters))
        {
            case Result.Ok(specializedTypeDefinition):
                switch (specializedTypeDefinition)
                {
                    case SpecializedTypeDefinition.Enum(constuctors):
                        Result.Ok(FollowedTypeDefinition.Enum(constuctors));
                        
                    case SpecializedTypeDefinition.Tuple(arguments):
                        Result.Ok(FollowedTypeDefinition.Tuple(arguments));
                        
                    case SpecializedTypeDefinition.Struct(fields):
                        Result.Ok(FollowedTypeDefinition.Struct(fields));
                        
                    case SpecializedTypeDefinition.Newtype(type):
                        if (type.getTypePath().toString() == startPath)
                        {
                            var path = type.getTypePath();
                            Result.Err(TypeFollowErrorKind.LoopedNewtype(path));
                        }
                        else
                        {
                            TypeReferenceTools._follow(type, startPath, source, definitionParameters);
                        }
                }
                
            case Result.Err(error):
                throw new IdlException(TypeSpecializeErrorKindTools.toString(error));
        }
    }
}

private class TypeSpecializer
{
    private var typeMap:Map<String, TypeReference>;
    private var dependenceMap:Map<String, TypeReferenceDependenceKind>;
    public var result(default, null):SpecializedTypeDefinition;
    
    public function new(definition:TypeDefinition, typeMap:Map<String, TypeReference>, dependenceMap:Map<String, TypeReferenceDependenceKind>)
    {
        this.dependenceMap = dependenceMap;
        this.typeMap = typeMap;
        
		result = switch (definition)
		{
			case TypeDefinition.Newtype(_, type):
                SpecializedTypeDefinition.Newtype(specializeTypeReference(type));
				
			case TypeDefinition.Enum(_, constructors):
                SpecializedTypeDefinition.Enum(
                    [
                        for (constructor in constructors)
                        {
                            EnumConstructorTools.mapOverTypeReference(constructor, specializeTypeReference);
                        }
                    ]
				);
                
			case TypeDefinition.Struct(_, elements):
                SpecializedTypeDefinition.Struct(
                    [
                        for (element in elements)
                        {
                            StructElementTools.mapOverTypeReference(element, specializeTypeReference);
                        }
                    ]
                );
                
            case TypeDefinition.Tuple(_, elements):
                SpecializedTypeDefinition.Tuple(
                    [
                        for (element in elements)
                        {
                            TupleElementTools.mapOverTypeReference(element, specializeTypeReference);
                        }
                    ]
                );
		}
    }
    
    private function specializeTypeReference(path:TypeReference):TypeReference
    {
        return TypeReferenceTools.specialize(path, typeMap, dependenceMap);
    }
}

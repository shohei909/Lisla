package lisla.idl.std.tools.idl;
import haxe.ds.Option;
import hxext.ds.Result;
import lisla.core.print.Printer;
import lisla.idl.exception.IdlException;
import lisla.idl.generator.source.IdlSourceProvider;
import lisla.idl.std.entity.idl.FollowedTypeDefinition;
import lisla.idl.std.entity.idl.SpecializedTypeDefinition;
import lisla.idl.std.entity.idl.TypeDefinition;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.entity.idl.TypeNameDeclaration;
import lisla.idl.std.entity.idl.TypeParameterDeclaration;
import lisla.idl.std.entity.idl.TypeReference;
import lisla.idl.std.entity.idl.TypeReferenceDependenceKind;
import lisla.idl.std.entity.idl.TypeReferenceParameter;
import lisla.idl.std.entity.idl.TypeReferenceParameterKind;
import lisla.idl.std.error.TypeFollowErrorKind;
import lisla.idl.std.error.TypeSpecializeErrorKind;
import lisla.idl.std.error.TypeSpecializeErrorKindTools;
using lisla.idl.std.tools.idl.TypeReferenceTools;
using lisla.idl.std.entity.idl.TypeParameterDeclaration;

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
                    var value = Printer.printLisla(referenceParameter.value);
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
    
    public static function follow(
        definition:TypeDefinition, 
        history:Array<String>, 
        source:IdlSourceProvider, 
        referenceParameters:Array<TypeReferenceParameter>, 
        definitionParameters:Array<TypeName>
    ):Result<FollowedTypeDefinition, TypeFollowErrorKind>
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
                        var path = type.getTypePath();
                        var pathName = path.toString();
                        if (history.indexOf(pathName) != -1)
                        {
                            Result.Err(TypeFollowErrorKind.LoopedNewtype(path));
                        }
                        else
                        {
                            TypeReferenceTools._follow(type, history.concat([pathName]), source, definitionParameters);
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

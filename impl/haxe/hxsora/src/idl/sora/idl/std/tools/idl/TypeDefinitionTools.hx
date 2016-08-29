package sora.idl.std.tools.idl;
import sora.idl.std.data.idl.TypeDefinition;
import sora.idl.std.data.idl.TypeName;
import sora.idl.std.data.idl.TypeNameDeclaration;
import sora.idl.std.data.idl.TypeParameterDeclaration;

class TypeDefinitionTools
{
	public static function getNameDeclaration(typeDefinition:TypeDefinition):TypeNameDeclaration
	{
		return switch (typeDefinition)
		{
			case 
				Struct(name, _) |
				Enum(name, _) |
				Alias(name, _) |
				Union(name, _) |
				Tuple(name, _):
					
				name;
		}
	}
	
	public static function getName(typeDefinition:TypeDefinition):TypeName
	{
		return TypeNameDeclarationTools.getName(getNameDeclaration(typeDefinition));
	}
	
	static public function getTypeParameters(typeDefinition:TypeDefinition):TypeParameterDeclaration
	{
		return TypeNameDeclarationTools.getParameters(getNameDeclaration(typeDefinition));
	}
}

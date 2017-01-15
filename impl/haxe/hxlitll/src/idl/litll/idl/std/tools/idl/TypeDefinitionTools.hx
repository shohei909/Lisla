package litll.idl.std.tools.idl;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeNameDeclaration;
import litll.idl.std.data.idl.TypeParameterDeclaration;

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
}

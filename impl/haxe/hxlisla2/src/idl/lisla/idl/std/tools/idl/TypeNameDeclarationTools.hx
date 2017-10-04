package arraytree.idl.std.tools.idl;
import arraytree.idl.std.entity.idl.TypeName;
import arraytree.idl.std.entity.idl.TypeNameDeclaration;
import arraytree.idl.std.entity.idl.TypeParameterDeclaration;

class TypeNameDeclarationTools
{
	public static function getTypeName(nameDeclaration:TypeNameDeclaration):TypeName
	{
		return switch (nameDeclaration)
		{
			case Primitive(typeName):
				typeName;
				
			case Generic(name, _):
				name;
		}
	}
	
	public static inline function getParameters(nameDeclaration:TypeNameDeclaration):Array<TypeParameterDeclaration>
	{
		return switch (nameDeclaration)
		{
			case Primitive(_):
				[];
				
			case Generic(_, parameters):
				parameters;
		}
	}
}
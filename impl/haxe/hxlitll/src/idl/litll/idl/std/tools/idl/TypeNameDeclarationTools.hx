package litll.idl.std.tools.idl;
import litll.idl.std.entity.idl.TypeName;
import litll.idl.std.entity.idl.TypeNameDeclaration;
import litll.idl.std.entity.idl.TypeParameterDeclaration;

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
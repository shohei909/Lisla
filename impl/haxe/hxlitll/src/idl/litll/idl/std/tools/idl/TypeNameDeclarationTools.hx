package litll.idl.std.tools.idl;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeNameDeclaration;
import litll.idl.std.data.idl.TypeParameterDeclaration;

class TypeNameDeclarationTools
{
	public static function getName(nameDeclaration:TypeNameDeclaration):TypeName
	{
		return switch (nameDeclaration)
		{
			case Primitive(typeName):
				typeName;
				
			case Generic(generic):
				generic.name;
		}
	}
	
	public static inline function getParameters(nameDeclaration:TypeNameDeclaration):Array<TypeParameterDeclaration>
	{
		return switch (nameDeclaration)
		{
			case Primitive(_):
				[];
				
			case Generic(generic):
				generic.parameters;
		}
	}
}
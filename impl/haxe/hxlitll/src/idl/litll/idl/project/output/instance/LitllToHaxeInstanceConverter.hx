package litll.idl.project.output.instance;
import haxe.macro.Expr;
import litll.core.Litll;
import litll.idl.std.data.idl.TypeReference;

class LitllToHaxeInstanceConverter
{
	public static function convertType(value:Litll, type:TypeReference, context:IdlToHaxeConvertContext):Expr
	{
		return macro null;
	}	
}

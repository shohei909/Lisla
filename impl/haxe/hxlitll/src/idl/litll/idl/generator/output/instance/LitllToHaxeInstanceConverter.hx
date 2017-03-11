package litll.idl.generator.output.instance;
import haxe.macro.Expr;
import litll.core.Litll;
import litll.idl.generator.output.HaxeConvertContext;
import litll.idl.std.entity.idl.TypeReference;

class LitllToHaxeInstanceConverter
{
	public static function convertType(value:Litll, type:TypeReference, context:HaxeConvertContext):Expr
	{
		return macro null;
	}	
}

package litll.idl.generator.output.haxe;
import haxe.macro.Expr.TypeDefinition;
import litll.idl.std.data.idl.TypePath;

interface HaxePrinter
{
	public function printType(type:TypeDefinition):Void;
}
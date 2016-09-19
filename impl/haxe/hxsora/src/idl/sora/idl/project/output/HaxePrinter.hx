package sora.idl.project.output;
import haxe.macro.Expr.TypeDefinition;
import sora.idl.std.data.idl.TypePath;

interface HaxePrinter
{
	public function printType(type:TypeDefinition):Void;
}

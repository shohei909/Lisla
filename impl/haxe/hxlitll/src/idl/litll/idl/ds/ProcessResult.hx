package litll.idl.ds;
import haxe.macro.Expr;

@:enum
abstract ProcessResult(Bool) to Bool
{
	var Success = false;
	var Failure = true;
}

package litll.idl.ds;

@:enum
abstract ProcessResult(Bool) to Bool
{
	var Success = false;
	var Failure = true;
}

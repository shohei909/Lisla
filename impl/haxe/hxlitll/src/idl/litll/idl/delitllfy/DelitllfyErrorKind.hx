package litll.idl.delitllfy;
import litll.core.Litll;

enum DelitllfyErrorKind
{
	// Recoverable
	CantBeArray;
	CantBeString;
	UnmatchedConst(actual:String, expected:String);
	UnmatchedEnumConstructor(expected:Array<String>);
	UnmatchedEnumLabel(expected:String);
	EndOfArray;
	TooLongArray;
	Recoverable(message:String);
	
	// NotRecoverable
	Fatal(message:String);
}

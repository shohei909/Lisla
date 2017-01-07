package litll.idl.delitllfy;

enum DelitllfyErrorKind
{
	// Recoverable
	CantBeArray;
	CantBeString;
	UnmatchedConst(actual:String, expected:String);
	UnmatchedEnumConstructor(actural:String, expected:Array<String>);
	UnmatchedUnion;
	EndOfArray;
	TooLongArray;
	Recoverable(message:String);
	
	// NotRecoverable
	Fatal(message:String);
}

package litll.idl.delitllfy;

enum LitllErrorKind
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
	Unknown(message:String);
}

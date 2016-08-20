package sora.idl.desoralize;

enum DesoralizeErrorKind
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

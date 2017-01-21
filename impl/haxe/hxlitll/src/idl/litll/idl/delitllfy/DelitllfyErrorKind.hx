package litll.idl.delitllfy;
import litll.core.Litll;

enum DelitllfyErrorKind
{
	CantBeArray;
	CantBeString;
	UnmatchedEnumConstructor(expected:Array<String>);
	UnmatchedLabel(expected:String);
	UnmatchedStructElement(expected:Array<String>);
	EndOfArray;
	TooLongArray;
	Fatal(message:String);
}

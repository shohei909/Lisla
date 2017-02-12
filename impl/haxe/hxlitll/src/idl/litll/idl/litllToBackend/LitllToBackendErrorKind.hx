package litll.idl.litllToBackend;
import litll.core.Litll;

enum LitllToBackendErrorKind
{
	CantBeArray;
	CantBeString;
	UnmatchedEnumConstructor(expected:Array<String>);
	UnmatchedLabel(expected:String);
	UnmatchedStructElement(expected:Array<String>);
	StructElementDuplicated(name:String);
    StructElementNotFound(name:String);
	EndOfArray;
	TooLongArray;
	Fatal(message:String);
}

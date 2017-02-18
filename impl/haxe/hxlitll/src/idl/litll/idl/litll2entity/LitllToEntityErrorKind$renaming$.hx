package litll.idl.litll2entity;
import litll.core.Litll;

enum LitllToEntityErrorKind
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

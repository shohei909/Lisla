package litll.idl.litll2entity.error;
import hxext.ds.Maybe;
import litll.core.Litll;
import litll.core.tag.Tag;

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

package lisla.idl.lisla2entity.error;
import hxext.ds.Maybe;
import lisla.core.Lisla;
import lisla.core.tag.Tag;

enum LislaToEntityErrorKind
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

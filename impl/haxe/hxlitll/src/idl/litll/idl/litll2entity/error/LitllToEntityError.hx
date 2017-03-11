package lisla.idl.lisla2entity.error;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.core.Lisla;
import lisla.core.LislaArray;
import lisla.core.LislaString;
import lisla.core.LislaTools;
import lisla.core.ds.SourceRange;
import lisla.core.error.InlineErrorSummary;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;
import lisla.idl.lisla2entity.error.LislaToEntityErrorTarget;

class LislaToEntityError 
{
	public var target(default, null):LislaToEntityErrorTarget;
	public var kind(default, null):LislaToEntityErrorKind;
	
	public function new (target:LislaToEntityErrorTarget, kind:LislaToEntityErrorKind)
	{
		this.target = target;
		this.kind = kind;
	}
	
	public static function ofString(string:LislaString, range:Maybe<SourceRange>, kind:LislaToEntityErrorKind):LislaToEntityError
	{
		return new LislaToEntityError(LislaToEntityErrorTarget.Str(string, range), kind);
	}
	
	public static function ofArray(array:LislaArray<Lisla>, index:Int, kind:LislaToEntityErrorKind):LislaToEntityError
	{
		return new LislaToEntityError(LislaToEntityErrorTarget.Arr(array, index), kind);
	}
	
	public static function ofLisla(lisla:Lisla, kind:LislaToEntityErrorKind):LislaToEntityError
	{
		return switch (lisla)
		{
			case Lisla.Str(string):
				ofString(string, Maybe.none(), kind);
				
			case Lisla.Arr(array):
				ofArray(array, -1, kind);
		}
	}
	
	public function getRange():Maybe<SourceRange>
	{
		return switch (target)
		{
			case LislaToEntityErrorTarget.Str(str, maybeRange):
				var maybeParentRange = str.tag.flatMap(function (t) return t.range);
				switch (maybeRange.toOption())
				{
					case Option.None:
						maybeParentRange;
						
					case Option.Some(range):
						maybeParentRange.flatMap(function (parentRange) return parentRange.concat(range));
				}
				
			case LislaToEntityErrorTarget.Arr(arr, index):
				if (index < 0)
				{
					arr.tag.flatMap(function (tag) return tag.range);
				}
				else if (index >= arr.data.length)
				{
					arr.tag.flatMap(function (tag) return tag.range);
				}
				else
				{
					LislaTools.getTag(arr.data[index]).flatMap(function (tag) return tag.range);
				}
		}
	}
	
	private function getKindString():String
	{
		return switch (kind)
		{
			case LislaToEntityErrorKind.UnmatchedEnumConstructor(expected):
				"unmatched enum constructor. '" + expected.join(" | ") + "' expected";
				
			case LislaToEntityErrorKind.UnmatchedStructElement(expected):
				"unmatched struct element. '" + expected.join(" | ") + "' expected";
                
			case LislaToEntityErrorKind.UnmatchedLabel(expected):
				"unmatched enum label. '" + expected + "' expected";
				
			case LislaToEntityErrorKind.StructElementDuplicated(name):
				"struct element '" + name + "' is duplicated";
                
			case LislaToEntityErrorKind.StructElementNotFound(name):
				"struct element '" + name + "' is not found";
				
			case LislaToEntityErrorKind.CantBeArray:
				"can't be array";
				
			case LislaToEntityErrorKind.CantBeString:
				"can't be string";
				
			case LislaToEntityErrorKind.TooLongArray:
				"too long array";
				
			case LislaToEntityErrorKind.EndOfArray:
				"end of array";
				
			case LislaToEntityErrorKind.Fatal(message):
				message;
		}
	}
    
    public function getSummary():InlineErrorSummary<LislaToEntityErrorKind>
    {
        return new InlineErrorSummary(
            getRange(),
            getKindString(),
            kind
        );
    }
}

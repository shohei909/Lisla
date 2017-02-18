package litll.idl.litll2entity;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.LitllString;
import litll.core.LitllTools;
import hxext.ds.Maybe;
import litll.core.ds.SourceRange;
import litll.core.error.LitllErrorSummary;

class LitllToEntityError 
{
	public var target(default, null):LitllToEntityErrorTarget;
	public var kind(default, null):LitllToEntityErrorKind;
	
	public function new (target:LitllToEntityErrorTarget, kind:LitllToEntityErrorKind)
	{
		this.target = target;
		this.kind = kind;
	}
	
	public static function ofString(string:LitllString, range:Maybe<SourceRange>, kind:LitllToEntityErrorKind):LitllToEntityError
	{
		return new LitllToEntityError(LitllToEntityErrorTarget.Str(string, range), kind);
	}
	
	public static function ofArray(array:LitllArray<Litll>, index:Int, kind:LitllToEntityErrorKind):LitllToEntityError
	{
		return new LitllToEntityError(LitllToEntityErrorTarget.Arr(array, index), kind);
	}
	
	public static function ofLitll(litll:Litll, kind:LitllToEntityErrorKind):LitllToEntityError
	{
		return switch (litll)
		{
			case Litll.Str(string):
				ofString(string, Maybe.none(), kind);
				
			case Litll.Arr(array):
				ofArray(array, -1, kind);
		}
	}
	
	public function getRange():Maybe<SourceRange>
	{
		return switch (target)
		{
			case LitllToEntityErrorTarget.Str(str, maybeRange):
				var maybeParentRange = str.tag.flatMap(function (t) return t.position);
				switch (maybeRange.toOption())
				{
					case Option.None:
						maybeParentRange;
						
					case Option.Some(range):
						maybeParentRange.flatMap(function (parentRange) return parentRange.concat(range));
				}
				
			case LitllToEntityErrorTarget.Arr(arr, index):
				if (index < 0)
				{
					arr.tag.flatMap(function (tag) return tag.position);
				}
				else if (index >= arr.data.length)
				{
					arr.tag.flatMap(function (tag) return tag.position);
				}
				else
				{
					LitllTools.getTag(arr.data[index]).flatMap(function (tag) return tag.position);
				}
		}
	}
	
	private function getKindString():String
	{
		return switch (kind)
		{
			case LitllToEntityErrorKind.UnmatchedEnumConstructor(expected):
				"unmatched enum constructor. '" + expected.join(" | ") + "' expected";
				
			case LitllToEntityErrorKind.UnmatchedStructElement(expected):
				"unmatched struct element. '" + expected.join(" | ") + "' expected";
                
			case LitllToEntityErrorKind.UnmatchedLabel(expected):
				"unmatched enum label. '" + expected + "' expected";
				
			case LitllToEntityErrorKind.StructElementDuplicated(name):
				"struct element '" + name + "' is duplicated";
                
			case LitllToEntityErrorKind.StructElementNotFound(name):
				"struct element '" + name + "' is not found";
				
			case LitllToEntityErrorKind.CantBeArray:
				"can't be array";
				
			case LitllToEntityErrorKind.CantBeString:
				"can't be string";
				
			case LitllToEntityErrorKind.TooLongArray:
				"too long array";
				
			case LitllToEntityErrorKind.EndOfArray:
				"end of array";
				
			case LitllToEntityErrorKind.Fatal(message):
				message;
		}
	}
    
    public function getSummary():LitllErrorSummary
    {
        return new LitllErrorSummary(getRange(), getKindString());
    }
}

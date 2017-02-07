package litll.idl.delitllfy;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.LitllString;
import litll.core.LitllTools;
import litll.core.ds.Maybe;
import litll.core.ds.SourceRange;
import litll.core.error.LitllErrorSummary;

class DelitllfyError 
{
	public var target(default, null):DelitllfyErrorTarget;
	public var kind(default, null):DelitllfyErrorKind;
	
	public function new (target:DelitllfyErrorTarget, kind:DelitllfyErrorKind)
	{
		this.target = target;
		this.kind = kind;
	}
	
	public static function ofString(string:LitllString, range:Maybe<SourceRange>, kind:DelitllfyErrorKind):DelitllfyError
	{
		return new DelitllfyError(DelitllfyErrorTarget.Str(string, range), kind);
	}
	
	public static function ofArray(array:LitllArray<Litll>, index:Int, kind:DelitllfyErrorKind):DelitllfyError
	{
		return new DelitllfyError(DelitllfyErrorTarget.Arr(array, index), kind);
	}
	
	public static function ofLitll(litll:Litll, kind:DelitllfyErrorKind):DelitllfyError
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
			case DelitllfyErrorTarget.Str(str, maybeRange):
				var maybeParentRange = str.tag.flatMap(function (t) return t.position);
				switch (maybeRange.toOption())
				{
					case Option.None:
						maybeParentRange;
						
					case Option.Some(range):
						maybeParentRange.flatMap(function (parentRange) return parentRange.concat(range));
				}
				
			case DelitllfyErrorTarget.Arr(arr, index):
				if (index < 0)
				{
					arr.tag.position;
				}
				else if (index >= arr.data.length)
				{
					arr.tag.position;
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
			case DelitllfyErrorKind.UnmatchedEnumConstructor(expected):
				"unmatched enum constructor. '" + expected.join(" | ") + "' expected";
				
			case DelitllfyErrorKind.UnmatchedStructElement(expected):
				"unmatched struct element. '" + expected.join(" | ") + "' expected";
                
			case DelitllfyErrorKind.UnmatchedLabel(expected):
				"unmatched enum label. '" + expected + "' expected";
				
			case DelitllfyErrorKind.StructElementDuplicated(name):
				"struct element '" + name + "' is duplicated";
                
			case DelitllfyErrorKind.StructElementNotFound(name):
				"struct element '" + name + "' is not found";
				
			case DelitllfyErrorKind.CantBeArray:
				"can't be array";
				
			case DelitllfyErrorKind.CantBeString:
				"can't be string";
				
			case DelitllfyErrorKind.TooLongArray:
				"too long array";
				
			case DelitllfyErrorKind.EndOfArray:
				"end of array";
				
			case DelitllfyErrorKind.Fatal(message):
				message;
		}
	}
    
    public function getSummary():LitllErrorSummary
    {
        return new LitllErrorSummary(getRange(), getKindString());
    }
}

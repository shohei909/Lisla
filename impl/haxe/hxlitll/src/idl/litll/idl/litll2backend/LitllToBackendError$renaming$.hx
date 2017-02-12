package litll.idl.litll2backend;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.LitllString;
import litll.core.LitllTools;
import litll.core.ds.Maybe;
import litll.core.ds.SourceRange;
import litll.core.error.LitllErrorSummary;

class LitllToBackendError 
{
	public var target(default, null):LitllToBackendErrorTarget;
	public var kind(default, null):LitllToBackendErrorKind;
	
	public function new (target:LitllToBackendErrorTarget, kind:LitllToBackendErrorKind)
	{
		this.target = target;
		this.kind = kind;
	}
	
	public static function ofString(string:LitllString, range:Maybe<SourceRange>, kind:LitllToBackendErrorKind):LitllToBackendError
	{
		return new LitllToBackendError(LitllToBackendErrorTarget.Str(string, range), kind);
	}
	
	public static function ofArray(array:LitllArray<Litll>, index:Int, kind:LitllToBackendErrorKind):LitllToBackendError
	{
		return new LitllToBackendError(LitllToBackendErrorTarget.Arr(array, index), kind);
	}
	
	public static function ofLitll(litll:Litll, kind:LitllToBackendErrorKind):LitllToBackendError
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
			case LitllToBackendErrorTarget.Str(str, maybeRange):
				var maybeParentRange = str.tag.flatMap(function (t) return t.position);
				switch (maybeRange.toOption())
				{
					case Option.None:
						maybeParentRange;
						
					case Option.Some(range):
						maybeParentRange.flatMap(function (parentRange) return parentRange.concat(range));
				}
				
			case LitllToBackendErrorTarget.Arr(arr, index):
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
			case LitllToBackendErrorKind.UnmatchedEnumConstructor(expected):
				"unmatched enum constructor. '" + expected.join(" | ") + "' expected";
				
			case LitllToBackendErrorKind.UnmatchedStructElement(expected):
				"unmatched struct element. '" + expected.join(" | ") + "' expected";
                
			case LitllToBackendErrorKind.UnmatchedLabel(expected):
				"unmatched enum label. '" + expected + "' expected";
				
			case LitllToBackendErrorKind.StructElementDuplicated(name):
				"struct element '" + name + "' is duplicated";
                
			case LitllToBackendErrorKind.StructElementNotFound(name):
				"struct element '" + name + "' is not found";
				
			case LitllToBackendErrorKind.CantBeArray:
				"can't be array";
				
			case LitllToBackendErrorKind.CantBeString:
				"can't be string";
				
			case LitllToBackendErrorKind.TooLongArray:
				"too long array";
				
			case LitllToBackendErrorKind.EndOfArray:
				"end of array";
				
			case LitllToBackendErrorKind.Fatal(message):
				message;
		}
	}
    
    public function getSummary():LitllErrorSummary
    {
        return new LitllErrorSummary(getRange(), getKindString());
    }
}

package litll.idl.delitllfy;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.LitllString;
import litll.core.LitllTools;
import litll.core.ds.Maybe;
import litll.core.ds.SourceRange;

class DelitllfyError 
{
	public var target(default, null):DelitllfyErrorTarget;
	public var kind(default, null):DelitllfyErrorKind;
	public var maybeCauses(default, null):Array<DelitllfyError>;
	public var followings(default, null):Array<DelitllfyError>;
    
	public function new (target:DelitllfyErrorTarget, kind:DelitllfyErrorKind, maybeCauses:Array<DelitllfyError>)
	{
		this.target = target;
		this.kind = kind;
		this.maybeCauses = maybeCauses;
		this.followings = [];
	}
	
	public static function ofString(string:LitllString, range:Maybe<SourceRange>, kind:DelitllfyErrorKind):DelitllfyError
	{
		return new DelitllfyError(DelitllfyErrorTarget.Str(string, range), kind, []);
	}
	
	public static function ofArray(array:LitllArray<Litll>, index:Int, kind:DelitllfyErrorKind, maybeCauses:Array<DelitllfyError>):DelitllfyError
	{
		return new DelitllfyError(DelitllfyErrorTarget.Arr(array, index), kind, maybeCauses);
	}
	
	public static function ofLitll(litll:Litll, kind:DelitllfyErrorKind):DelitllfyError
	{
		return switch (litll)
		{
			case Litll.Str(string):
				ofString(string, Maybe.none(), kind);
				
			case Litll.Arr(array):
				ofArray(array, -1, kind, []);
		}
	}
	
	public function toString():String
	{
		return makeErrorMessages([], false).join("\n");
	}
	
	private function makeErrorMessages(array:Array<String>, warning:Bool):Array<String>
	{
		for (error in maybeCauses)
		{
			error.makeErrorMessages(array, true);
		}
		
		var str = if (warning) "Warning" else "Error";
		
		getRange().iter(function (range) str += ":" + range.toString());
		array.push(str + ": " + getKindString());
		
		for (following in followings)
		{
			following.makeErrorMessages(array, warning);
		}
		
		return array;
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
				
			case DelitllfyErrorKind.StructElementDupplicated(name):
				"struct element '" + name + "' is dupplicated";
                
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
}

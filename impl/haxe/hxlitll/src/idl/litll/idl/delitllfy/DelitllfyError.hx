package litll.idl.delitllfy;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.LitllString;
import litll.core.LitllTools;
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
	
	public static function ofString(string:LitllString, range:Option<SourceRange>, kind:DelitllfyErrorKind):DelitllfyError
	{
		return new DelitllfyError(DelitllfyErrorTarget.Str(string, range), kind, []);
	}
	
	public static function ofArray(array:LitllArray, index:Int, kind:DelitllfyErrorKind, maybeCauses:Array<DelitllfyError>):DelitllfyError
	{
		return new DelitllfyError(DelitllfyErrorTarget.Arr(array, index), kind, maybeCauses);
	}
	
	public static function ofLitll(litll:Litll, kind:DelitllfyErrorKind):DelitllfyError
	{
		return switch (litll)
		{
			case Litll.Str(string):
				ofString(string, Option.None, kind);
				
			case Litll.Arr(array):
				ofArray(array, -1, kind, []);
		}
	}
	
	public function recoverable():Bool
	{
		return switch (kind)
		{
			case DelitllfyErrorKind.UnmatchedUnion | 
				DelitllfyErrorKind.UnmatchedEnumConstructor(_) | 
				DelitllfyErrorKind.UnmatchedConst(_) | 
				DelitllfyErrorKind.CantBeArray | 
				DelitllfyErrorKind.CantBeString |
				DelitllfyErrorKind.TooLongArray |
				DelitllfyErrorKind.EndOfArray |
				DelitllfyErrorKind.Recoverable(_):
				true;
				
			case DelitllfyErrorKind.Unknown(_):
				false;
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
		
		switch (getRange())
		{
			case Option.Some(range):
				str += ":" + range.toString();
				
			case Option.None:
		}
		
		array.push(str + ": " + getKindString());
		
		for (following in followings)
		{
			following.makeErrorMessages(array, warning);
		}
		
		return array;
	}
	
	private function getRange():Option<SourceRange>
	{
		return switch (target)
		{
			case DelitllfyErrorTarget.Str(str, Option.None):
				str.tag.position;
				
			case DelitllfyErrorTarget.Str(str, Option.Some(range)):
				switch (str.tag.position)
				{
					case Option.Some(parentRange):
						Option.Some(parentRange.concat(range));
					
					case Option.None:
						Option.None;
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
					LitllTools.getTag(arr.data[index]).position;
				}
		}
	}
	
	private function getKindString():String
	{
		return switch (kind)
		{
			case DelitllfyErrorKind.UnmatchedUnion:
				"unmatched union";
				
			case DelitllfyErrorKind.UnmatchedEnumConstructor(actual, expected):
				"unmatched enum constructor. '" + expected.join(" | ") + "' expected, but actual '" + actual + "'";
				
			case DelitllfyErrorKind.UnmatchedConst(actual, expected):
				"unmatched const. '" + expected + "' expected, but actual '" + actual + "'";
				
			case DelitllfyErrorKind.CantBeArray:
				"can't be array";
				
			case DelitllfyErrorKind.CantBeString:
				"can't be string";
				
			case DelitllfyErrorKind.TooLongArray:
				"too long array";
				
			case DelitllfyErrorKind.EndOfArray:
				"end of array";
				
			case DelitllfyErrorKind.Recoverable(message):
				message;
				
			case DelitllfyErrorKind.Unknown(message):
				message;
		}
	}
}

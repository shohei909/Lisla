package litll.idl.delitllfy;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.LitllString;
import litll.core.LitllTools;
import litll.core.ds.SourceRange;

class LitllError 
{
	public var target(default, null):LitllErrorTarget;
	public var kind(default, null):LitllErrorKind;
	public var maybeCauses(default, null):Array<LitllError>;
	public var followings(default, null):Array<LitllError>;
	
	public function new (target:LitllErrorTarget, kind:LitllErrorKind, maybeCauses:Array<LitllError>)
	{
		this.target = target;
		this.kind = kind;
		this.maybeCauses = maybeCauses;
		this.followings = [];
	}
	
	public static function ofString(string:LitllString, range:Option<SourceRange>, kind:LitllErrorKind):LitllError
	{
		return new LitllError(LitllErrorTarget.Str(string, range), kind, []);
	}
	
	public static function ofArray(array:LitllArray, index:Int, kind:LitllErrorKind, maybeCauses:Array<LitllError>):LitllError
	{
		return new LitllError(LitllErrorTarget.Arr(array, index), kind, maybeCauses);
	}
	
	public static function ofLitll(litll:Litll, kind:LitllErrorKind):LitllError
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
			case LitllErrorKind.UnmatchedUnion | 
				LitllErrorKind.UnmatchedEnumConstructor(_) | 
				LitllErrorKind.UnmatchedConst(_) | 
				LitllErrorKind.CantBeArray | 
				LitllErrorKind.CantBeString |
				LitllErrorKind.TooLongArray |
				LitllErrorKind.EndOfArray |
				LitllErrorKind.Recoverable(_):
				true;
				
			case LitllErrorKind.Unknown(_):
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
			case LitllErrorTarget.Str(str, Option.None):
				str.tag.position;
				
			case LitllErrorTarget.Str(str, Option.Some(range)):
				switch (str.tag.position)
				{
					case Option.Some(parentRange):
						Option.Some(parentRange.concat(range));
					
					case Option.None:
						Option.None;
				}
			case LitllErrorTarget.Arr(arr, index):
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
			case LitllErrorKind.UnmatchedUnion:
				"unmatched union";
				
			case LitllErrorKind.UnmatchedEnumConstructor(actual, expected):
				"unmatched enum constructor. '" + expected.join(" | ") + "' expected, but actual '" + actual + "'";
				
			case LitllErrorKind.UnmatchedConst(actual, expected):
				"unmatched const. '" + expected + "' expected, but actual '" + actual + "'";
				
			case LitllErrorKind.CantBeArray:
				"can't be array";
				
			case LitllErrorKind.CantBeString:
				"can't be string";
				
			case LitllErrorKind.TooLongArray:
				"too long array";
				
			case LitllErrorKind.EndOfArray:
				"end of array";
				
			case LitllErrorKind.Recoverable(message):
				message;
				
			case LitllErrorKind.Unknown(message):
				message;
		}
	}
}

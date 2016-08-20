package sora.idl.desoralize;
import haxe.ds.Option;
import sora.core.Sora;
import sora.core.SoraArray;
import sora.core.SoraString;
import sora.core.SoraTools;
import sora.core.ds.SourceRange;

class DesoralizeError 
{
	public var target(default, null):DesoralizeErrorTarget;
	public var kind(default, null):DesoralizeErrorKind;
	public var maybeCauses(default, null):Array<DesoralizeError>;
	public var followings(default, null):Array<DesoralizeError>;
	
	public function new (target:DesoralizeErrorTarget, kind:DesoralizeErrorKind, maybeCauses:Array<DesoralizeError>)
	{
		this.target = target;
		this.kind = kind;
		this.maybeCauses = maybeCauses;
		this.followings = [];
	}
	
	public static function ofString(string:SoraString, range:Option<SourceRange>, kind:DesoralizeErrorKind):DesoralizeError
	{
		return new DesoralizeError(DesoralizeErrorTarget.Str(string, range), kind, []);
	}
	
	public static function ofArray(array:SoraArray, index:Int, kind:DesoralizeErrorKind, maybeCauses:Array<DesoralizeError>):DesoralizeError
	{
		return new DesoralizeError(DesoralizeErrorTarget.Arr(array, index), kind, maybeCauses);
	}
	
	public static function ofSora(sora:Sora, kind:DesoralizeErrorKind):DesoralizeError
	{
		return switch (sora)
		{
			case Sora.Str(string):
				ofString(string, Option.None, kind);
				
			case Sora.Arr(array):
				ofArray(array, -1, kind, []);
		}
	}
	
	public function recoverable():Bool
	{
		return switch (kind)
		{
			case DesoralizeErrorKind.UnmatchedUnion | 
				DesoralizeErrorKind.UnmatchedEnumConstructor(_) | 
				DesoralizeErrorKind.UnmatchedConst(_) | 
				DesoralizeErrorKind.CantBeArray | 
				DesoralizeErrorKind.CantBeString |
				DesoralizeErrorKind.TooLongArray |
				DesoralizeErrorKind.EndOfArray |
				DesoralizeErrorKind.Recoverable(_):
				true;
				
			case DesoralizeErrorKind.Unknown(_):
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
			case DesoralizeErrorTarget.Str(str, Option.None):
				str.tag.position;
				
			case DesoralizeErrorTarget.Str(str, Option.Some(range)):
				switch (str.tag.position)
				{
					case Option.Some(parentRange):
						Option.Some(parentRange.concat(range));
					
					case Option.None:
						Option.None;
				}
			case DesoralizeErrorTarget.Arr(arr, index):
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
					SoraTools.getTag(arr.data[index]).position;
				}
		}
	}
	
	private function getKindString():String
	{
		return switch (kind)
		{
			case DesoralizeErrorKind.UnmatchedUnion:
				"unmatched union";
				
			case DesoralizeErrorKind.UnmatchedEnumConstructor(actual, expected):
				"unmatched enum constructor. '" + expected.join(" | ") + "' expected, but actual '" + actual + "'";
				
			case DesoralizeErrorKind.UnmatchedConst(actual, expected):
				"unmatched const. '" + expected + "' expected, but actual '" + actual + "'";
				
			case DesoralizeErrorKind.CantBeArray:
				"can't be array";
				
			case DesoralizeErrorKind.CantBeString:
				"can't be string";
				
			case DesoralizeErrorKind.TooLongArray:
				"too long array";
				
			case DesoralizeErrorKind.EndOfArray:
				"end of array";
				
			case DesoralizeErrorKind.Recoverable(message):
				message;
				
			case DesoralizeErrorKind.Unknown(message):
				message;
		}
	}
}

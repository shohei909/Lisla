package format.sora.parser;
import format.sora.data.SoraArray;
import format.sora.tag.Range;
import haxe.ds.Option;

class ParseErrorEntry
{
	public var kind(default, null):ParseErrorKind;
	public var position(default, null):Range;
	
	public inline function new(kind:ParseErrorKind, position:Range) 
	{
		this.kind = kind;
		this.position = position;
	}
}

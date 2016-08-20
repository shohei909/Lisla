package sora.core.tag;
import haxe.ds.Option;
import sora.core.tag.entry.StringFormatTagEntry;

class ArrayTag extends Tag
{
	public var format:Option<StringFormatTagEntry>;
	
	public function new() 
	{
		super();
		format = Option.None;
	}
}

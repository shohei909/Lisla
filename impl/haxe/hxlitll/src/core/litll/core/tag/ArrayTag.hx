package litll.core.tag;
import haxe.ds.Option;
import hxext.ds.Maybe;
import litll.core.tag.entry.StringFormatTagEntry;

class ArrayTag extends Tag
{
	public var format:Maybe<StringFormatTagEntry>;
	
	public function new() 
	{
		super();
		format = Maybe.none();
	}
}

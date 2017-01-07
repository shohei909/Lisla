package litll.core;
import litll.core.ds.Maybe;
import litll.core.tag.StringTag;

class LitllString 
{
	public var data:String;
	public var tag:Maybe<StringTag>;
	
	public function new (data:String, ?tag:Maybe<StringTag>) 
	{
		this.data = data;
		this.tag = tag;
	}
}

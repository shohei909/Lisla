package litll.core;
import litll.core.tag.StringTag;

class LitllString 
{
	public var data:String;
	public var tag:StringTag;
	
	public function new (data:String, ?tag:StringTag) 
	{
		this.data = data;
		this.tag = if (tag == null) new StringTag() else tag;
	}
}

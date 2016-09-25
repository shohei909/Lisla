package litll.core;
import litll.core.Litll;
import litll.core.tag.ArrayTag;
import litll.core.tag.StringTag;

class LitllArray
{
	public var data:Array<Litll>;
	public var tag:ArrayTag;
	
	public function new (data:Array<Litll>, ?tag:ArrayTag):Void 
	{
		this.data = data;
		this.tag = if (tag == null) new ArrayTag() else tag;
	}
}

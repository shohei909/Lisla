package litll.core;
import litll.core.Litll;
import litll.core.tag.ArrayTag;
import litll.core.tag.StringTag;

class LitllArray<T>
{
	public var data:Array<T>;
	public var tag:ArrayTag;
	
	public function new (data:Array<T>, ?tag:ArrayTag):Void 
	{
		this.data = data;
		this.tag = if (tag == null) new ArrayTag() else tag;
	}
}

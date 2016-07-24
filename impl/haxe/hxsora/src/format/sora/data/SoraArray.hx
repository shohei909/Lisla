package format.sora.data;
import format.sora.tag.Tag;

class SoraArray
{
	public var data:Array<Sora>;
	public var tag:Tag;
	
	public function new (data:Array<Sora>, tag:Tag):Void 
	{
		this.data = data;
		this.tag = tag;
	}
}

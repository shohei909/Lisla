package format.sora.data;
import format.sora.tag.Tag;

class SoraString 
{
	public var data:String;
	public var tag:Tag;
	
	public function new (data:String, ?tag:Tag) {
		this.data = data;
		
		if (tag == null)
		{
			this.tag = new Tag();
		} 
		else 
		{
			this.tag = tag;
		}
	}
}

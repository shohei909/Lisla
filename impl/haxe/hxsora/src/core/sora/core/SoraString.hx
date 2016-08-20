package sora.core;
import sora.core.tag.StringTag;

class SoraString 
{
	public var data:String;
	public var tag:StringTag;
	
	public function new (data:String, ?tag:StringTag) 
	{
		this.data = data;
		this.tag = if (tag == null) new StringTag() else tag;
	}
}

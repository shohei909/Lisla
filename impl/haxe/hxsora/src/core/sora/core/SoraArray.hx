package sora.core;
import sora.core.Sora;
import sora.core.tag.ArrayTag;
import sora.core.tag.StringTag;

class SoraArray
{
	public var data:Array<Sora>;
	public var tag:ArrayTag;
	
	public function new (data:Array<Sora>, ?tag:ArrayTag):Void 
	{
		this.data = data;
		this.tag = if (tag == null) new ArrayTag() else tag;
	}
}

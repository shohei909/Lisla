package format.sora.tag;

/**
 * ...
 * @author shohei909
 */
class DocumentTag
{
	public var content:String;
	public var positions:Array<Range>;
	
	public function new() 
	{
		this.content = "";
		this.positions = [];
		
	}
}

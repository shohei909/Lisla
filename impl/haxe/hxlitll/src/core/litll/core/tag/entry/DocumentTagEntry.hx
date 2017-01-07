package litll.core.tag.entry;
import litll.core.ds.SourceRange;

/**
 * ...
 * 
 */
class DocumentTagEntry
{
	public var content:String;
	public var positions:Array<SourceRange>;
	
	public function new() 
	{
		this.content = "";
		this.positions = [];
		
	}
}

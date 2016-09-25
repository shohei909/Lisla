package litll.core.tag;
import haxe.ds.Option;
import litll.core.ds.SourceRange;
import litll.core.tag.entry.DocumentTagEntry;

class Tag
{
	public var document:Option<DocumentTagEntry>;
	public var position:Option<SourceRange>;
	
	public function new() 
	{
		position = Option.None;
		document = Option.None;
	}
}
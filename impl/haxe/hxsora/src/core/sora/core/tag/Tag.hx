package sora.core.tag;
import haxe.ds.Option;
import sora.core.ds.SourceRange;
import sora.core.tag.entry.DocumentTagEntry;

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
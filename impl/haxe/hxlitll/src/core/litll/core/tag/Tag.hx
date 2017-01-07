package litll.core.tag;
import haxe.ds.Option;
import litll.core.ds.Maybe;
import litll.core.ds.SourceRange;
import litll.core.tag.entry.DocumentTagEntry;

class Tag
{
	public var document:Maybe<DocumentTagEntry>;
	public var position:Maybe<SourceRange>;
	
	public function new() 
	{
		position = Maybe.none();
		document = Maybe.none();
	}
}

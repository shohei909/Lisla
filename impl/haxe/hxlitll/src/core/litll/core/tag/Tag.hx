package litll.core.tag;
import haxe.ds.Option;
import hxext.ds.Maybe;
import litll.core.ds.SourceRange;
import litll.core.tag.entry.DocumentTagEntry;

class Tag
{
	public var document:Maybe<DocumentTagEntry>;
	public var range:Maybe<SourceRange>;
	
	public function new() 
	{
		range = Maybe.none();
		document = Maybe.none();
	}
}

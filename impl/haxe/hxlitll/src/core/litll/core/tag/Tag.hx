package lisla.core.tag;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.core.ds.SourceRange;
import lisla.core.tag.entry.DocumentTagEntry;

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

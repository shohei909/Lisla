package lisla.error.core;
import haxe.ds.Option;
import lisla.data.meta.position.Range;

interface InlineError 
    extends InlineErrorHolder
    extends ElementaryErrorHolder
{
    public function getOptionRange():Option<Range>;
}

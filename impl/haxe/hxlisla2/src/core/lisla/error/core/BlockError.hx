package lisla.error.core;
import haxe.ds.Option;
import lisla.data.meta.position.SourceMap;

interface BlockError 
    extends BlockErrorHolder
    extends InlineErrorHolder
{
    public function getOptionSourceMap():Option<SourceMap>;
}

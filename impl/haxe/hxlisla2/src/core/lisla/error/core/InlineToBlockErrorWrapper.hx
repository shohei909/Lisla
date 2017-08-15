package lisla.error.core;
import haxe.ds.Option;
import lisla.data.meta.position.OptionSourceMapHolderImpl;
import lisla.data.meta.position.SourceMap;

class InlineToBlockErrorWrapper<WrappedType:InlineErrorHolder> 
    extends OptionSourceMapHolderImpl
    implements BlockError
{
    public var error:WrappedType;
    
    public function new(error:WrappedType, sourceMap:Option<SourceMap>) 
    {
        this.error = error;
        super(sourceMap);
    }
    
    public function getInlineError():InlineError
    {
        return error.getInlineError();
    }
    
    public function getBlockError():BlockError
    {
        return this;
    }
}

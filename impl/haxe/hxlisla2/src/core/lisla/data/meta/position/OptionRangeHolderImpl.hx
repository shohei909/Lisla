package lisla.error.core;
import haxe.ds.Option;
import lisla.data.meta.position.Range;

class OptionRangeHolderImpl
{
    private var range:Option<Range>;
    
    public function new(range:Option<Range>) 
    {
        this.range = range;
    }
    
    public function getOptionRange():Option<Range>
    {
        return range;
    }
}

package lisla.data.meta.position;
import haxe.ds.Option;
import lisla.data.meta.position.SourceMap;

class OptionSourceMapHolderImpl 
{   
    private var sourceMap:Option<SourceMap>;
    
    public function new(sourceMap:Option<SourceMap>) 
    {
        this.sourceMap = sourceMap;
    }
    
    public function getOptionSourceMap():Option<SourceMap>
    {
        return sourceMap;
    }
}

package lisla.data.meta.comment;
import haxe.ds.Option;
import lisla.data.meta.position.RangeCollection;
import lisla.parse.result.AlTreeParseResult;

class DocumentComment 
{
    public var rawData:String;
    public var ranges:RangeCollection;
    public var parsedData:Option<AlTreeParseResult>;
    
    public function new(rawData:String, ranges:RangeCollection) 
    {
        parsedData = Option.None;
    }
}

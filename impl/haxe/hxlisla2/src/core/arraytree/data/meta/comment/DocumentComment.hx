package arraytree.data.meta.comment;
import haxe.ds.Option;
import arraytree.data.meta.position.RangeCollection;
import arraytree.parse.result.ArrayTreeParseResult;

class DocumentComment 
{
    public var rawData:String;
    public var ranges:RangeCollection;
    public var parsedData:Option<ArrayTreeParseResult>;
    
    public function new(rawData:String, ranges:RangeCollection) 
    {
        this.rawData = rawData;
        this.ranges = ranges;
        parsedData = Option.None;
    }
}

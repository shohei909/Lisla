package lisla.data.meta.position;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceMap;

class SourceMap
{
    public var ranges(default, null):RangeCollection;
    public var lineIndexes(default, null):LineIndexes;
    
    public function new(
        ranges:RangeCollection,
        lines:LineIndexes
    ) 
    {
        this.ranges = ranges;
        this.lineIndexes = lines;
    }
    
    public function merge(localMap:SourceMap):SourceMap
    {
        return new SourceMap(
            ranges.merge(localMap.ranges),
            lineIndexes
        );
    }
    
    public function mergeRange(range:Range):SourceMap
    {
        return new SourceMap(
            new RangeCollection(ranges.mergeRange(range)),
            lineIndexes
        );
    }
    
    public function getRangesString():String
    {
        return ranges.toString();
    }
    
    public function getLinesString():String
    {
        return getIncludedLines().join(",");
    }
    
    public function getIncludedLines():Array<Int>
    {
        var result = [];
        var currentLineNumber = -1;
        for (range in ranges.ranges)
        {
            var startLineNumber = lineIndexes.getLineNumber(range.start);
            if (currentLineNumber < startLineNumber)
            {
                result.push(startLineNumber);
            }
            
            var endLineNumber = lineIndexes.getLineNumber(range.end);
            for (lineNumber in startLineNumber...endLineNumber)
            {
                result.push(lineNumber + 1);
            }
            
            currentLineNumber = endLineNumber;
        }
        
        return result;
    }
    
    public static function mergeOption(parentSourceMap:Option<SourceMap>, localSourceMap:Option<SourceMap>):Option<SourceMap>
    {
        return switch [parentSourceMap, localSourceMap]
        {
            case [Option.Some(_parentSourceMap), Option.Some(_localSourceMap)]:
                Option.Some(_parentSourceMap.merge(_localSourceMap));
                
            case _:
                Option.None;
        }
    }
}

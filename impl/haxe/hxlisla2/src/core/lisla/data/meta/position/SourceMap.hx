package lisla.data.meta.position;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceMap;

class SourceMap
{
    public var ranges(default, null):RangeCollection;
    public var lines(default, null):LineIndexes;
    
    public function new(
        ranges:RangeCollection,
        lines:LineIndexes
    ) 
    {
        this.ranges = ranges;
        this.lines = lines;
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
            var startLineNumber = lines.getLineNumber(range.start);
            if (currentLineNumber < startLineNumber)
            {
                result.push(startLineNumber);
            }
            
            var endLineNumber = lines.getLineNumber(range.end);
            for (lineNumber in startLineNumber...endLineNumber)
            {
                result.push(lineNumber + 1);
            }
            
            currentLineNumber = endLineNumber;
        }
        
        return result;
    }
}

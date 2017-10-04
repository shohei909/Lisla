package arraytree.data.meta.position;
import haxe.ds.Option;
import arraytree.data.meta.position.Range;
import arraytree.data.meta.position.SourceMap;

class SourceMap
{
    public var lines(default, null):LineIndexes;
    public var ranges(default, null):RangeCollection;
    
    public function new(
        lines:LineIndexes,
        ranges:RangeCollection
    ) 
    {
        this.lines = lines;
        this.ranges = ranges;
    }
    
    public function toString():String
    {
        return getLinesString() + " (character:" + getRangesString() + ")";
    }
    
    public function getRangesString():String
    {
        return ranges.toString();
    }
    
    public function getLinesString():String
    {
        var lines = getIncludedLines();
        return if (lines.length == 0) "?" else lines.join(",");
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
    
    public function mergeRange(range:Range):SourceMap
    {
        return new SourceMap(
            lines,
            new RangeCollection(ranges.mergeRange(range))
        );
    }
    
    public function mergeRanges(childRanges:Array<Range>):SourceMap
    {
        return new SourceMap(
            lines,
            new RangeCollection(ranges.mergeRanges(childRanges))
        );
    }
}

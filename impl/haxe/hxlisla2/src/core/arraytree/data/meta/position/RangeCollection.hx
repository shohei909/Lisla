package arraytree.data.meta.position;
import haxe.ds.Option;
import arraytree.algorithm.SearchTools;
import arraytree.error.exception.FatalException;

class RangeCollection 
{
    public var ranges(default, null):Array<Range>;
    public var indexes(default, null):Array<CodePointIndex>;
	
    public function new(sourceRanges:Array<Range>)
    {
        this.ranges = [];
        
        var index = new CodePointIndex(0);
        this.indexes = [index];
        
        for (range in sourceRanges)
        {
            ranges.push(range);
            index += range.length;
            indexes.push(index);
        }
    }
    
    public function merge(localRanges:RangeCollection):RangeCollection
    {
        var result = mergeRanges(localRanges.ranges);
        return new RangeCollection(result);
    }
    
    public function mergeRanges(localRanges:Array<Range>):Array<Range>
    {
        return [
            for (range in localRanges)
            {
                for (localRange in mergeRange(range))
                {
                    localRange;
                }
            }
        ];
    }
    
    public function mergeRange(localRange:Range):Array<Range>
    {
        var length = ranges.length;
        var start = if (localRange.start < new CodePointIndex(0)) new CodePointIndex(0) else localRange.start;
        
        var last = indexes[length];
        var end = if (last < localRange.end) last else localRange.end;
     
        var startRangeIndex = getRangeIndexAt(localRange.start);
        var endRangeIndex = getRangeIndexAt(localRange.end);
        
        var result = [];
        inline function add(parentRange:Range, startPosition:CodePointIndex, endPosition:CodePointIndex):Void
        {
            var range = Range.createWithLength(parentRange.start + startPosition, endPosition - startPosition);
            result.push(range);
        }
        
        var inlinePosition = localRange.start - indexes[startRangeIndex];
        for (index in startRangeIndex...endRangeIndex)
        {
            var parentRange = ranges[index];
            add(parentRange, inlinePosition, parentRange.length);
            inlinePosition = new CodePointIndex(0);
        }
        
        var endInlinePosition = localRange.end - indexes[endRangeIndex];
        if (endRangeIndex < length)
        {
            var parentRange = ranges[endRangeIndex];
            add(parentRange, inlinePosition, endInlinePosition);
        }
        return result;
    }
    
    public function getRangeIndexAt(targetIndex:CodePointIndex):Int
    {
		return SearchTools.binarySearch(
            indexes, 
            targetIndex, 
            function (index:CodePointIndex):Float return index
        );
    }
    
    public function toString():String
    {
        var strings = [for (range in ranges) range.toString()];
        return if (strings.length == 0) "?" else strings.join(",");
    }
}

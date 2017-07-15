package lisla.data.meta.position;
import lisla.algorithm.SearchTools;
import lisla.error.exception.FatalException;

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
            if (range.length <= new CodePointIndex(0))
            {
                continue;
            }
            
            ranges.push(range);
            index += range.length;
            indexes.push(index);
        }
    }
    
    public function localize(localRanges:RangeCollection):RangeCollection
    {
        var result = [];
        
        for (range in localRanges.ranges)
        {
            for (localRange in localizeRange(range))
            {
                result.push(localRange);
            }
        }
        
        return new RangeCollection(result);
    }
    
    public function localizeRange(localRange:Range):Array<Range>
    {
        var length = ranges.length;
        if (localRange.start < new CodePointIndex(0))
        {
            throw new FatalException("localRange.start is lower out of range.", RangeCollection, "LocalRangeStartIsLowerOutOfRange");
        }
        var last = indexes[length];
        if (last < localRange.end)
        {
            throw new FatalException("localRange.end is higher out of range.", RangeCollection, "LocalRangeEndIsUpperOutOfRange");
        }
     
        var startRangeIndex = getRangeIndexAt(localRange.start);
        var endRangeIndex = getRangeIndexAt(localRange.end);
        
        var result = [];
        inline function add(parentRange:Range, startPosition:CodePointIndex, endPosition:CodePointIndex):Void
        {
            var range = Range.createWithEnd(parentRange.start + startPosition, endPosition - startPosition);
            if (range.length > new CodePointIndex(0))
            {
                result.push(range);
            }
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
        return [for (range in ranges) range.toString()].join(",");
    }
}

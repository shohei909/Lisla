package arraytree.data.meta.position;
import arraytree.algorithm.SearchTools;
import arraytree.data.meta.position.PositionWithLineNumber;

class LineIndexes
{
	public var lineStartIndexes(default, null):Array<CodePointIndex>;
	
	public var lineNumber(get, never):Int;
	private function get_lineNumber():Int
	{
		return lineStartIndexes.length;
	}
	
	public function new ()
	{
		this.lineStartIndexes = [new CodePointIndex(0)];
	}
	
	public function addLine(lineStartIndex:CodePointIndex):Void
	{
		lineStartIndexes.push(lineStartIndex);
	}
	
	public inline function getPositionWithLineNumber(targetIndex:CodePointIndex):PositionWithLineNumber
	{
		var targetLineNumber = getLineNumber(targetIndex);
        return if (targetIndex == -1)
		{
			new PositionWithLineNumber(0, new CodePointIndex(0));
		}
		else
		{
			var targetLineStartIndex = lineStartIndexes[targetLineNumber];
			new PositionWithLineNumber(targetLineNumber, targetIndex - targetLineStartIndex);
		}
	}
    
    public inline function getLineNumber(targetIndex:CodePointIndex):Int
    {
        return SearchTools.binarySearch(
            lineStartIndexes, 
            targetIndex, 
            function (index:CodePointIndex):Float return index
        );
    }
}

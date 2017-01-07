package litll.core.ds;
import haxe.ds.Option;
import litll.core.math.Search.SearchTools;

class SourceMap
{
	private var lines:Array<LinePosition>;
	
	public var lineNumber(get, never):Int;
	private function get_lineNumber():Int
	{
		return lines.length;
	}
	
	public function new (inner:Int, outer:Int, outerLine:Int, padding:Int)
	{
		lines = [new LinePosition(inner, outer, outerLine, padding)];
	}
	
	public function addLine(inner:Int, outer:Int, outerLine:Int, padding:Int):Void
	{
		lines.push(new LinePosition(inner, outer, outerLine, padding));
	}
	
	public inline function getOuterPositionOf(targetInner:Int):SourcePosition
	{
		var targetIndex = SearchTools.binarySearch(lines, targetInner, function (line:LinePosition):Float return line.innerIndex);
		return if (targetIndex == -1)
		{
			var line = lines[0];
			new SourcePosition(line.outerLine, line.padding, line.outerIndex);
		}
		else
		{
			var line = lines[targetIndex];
			var offset = targetInner - line.innerIndex;
			new SourcePosition(line.outerLine, line.padding + offset, line.outerIndex + offset);
		}
	}
}

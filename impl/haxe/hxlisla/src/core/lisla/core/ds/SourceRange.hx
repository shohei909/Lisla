package lisla.core.ds;
import lisla.core.LislaString;

/**
 * [low, high)
 */
class SourceRange
{
	public var map:SourceMap;
	public var low:Int;
	public var high:Int;
	
	public inline function new(map:SourceMap, low:Int, high:Int) 
	{
		this.map = map;
		this.low = low;
		this.high = high;
	}
	
	public function contains(value:Int):Bool 
	{
		return low <= value && value < high;
	}
	
	public function concat(child:SourceRange):SourceRange 
	{
		return new SourceRange(
			this.map,
			child.map.getOuterPositionOf(child.low).index,
			child.map.getOuterPositionOf(child.high).index
		);
	}
    
	public function toString():String
	{
		var lowPosition = map.getOuterPositionOf(low);
		var highPosition = map.getOuterPositionOf(high);
		
		return lowPosition.toString() + "-" + highPosition.toString();
	}
    
	public function toLislaArray():LislaArray<Lisla>
	{
		var lowPosition = map.getOuterPositionOf(low);
		var highPosition = map.getOuterPositionOf(high);
		
		return new LislaArray(
            [
                Lisla.Str(new LislaString(lowPosition.toString())), 
                Lisla.Str(new LislaString(highPosition.toString()))
            ]
        );
	}
}

package format.sora.tag;

// [left, right)
class Range
{
	public var left:Int;
	public var right:Int;
	
	public inline function new(left:Int, right:Int) 
	{
		this.left = left;
		this.right = right;
		
	}
	
	public function contains(value:Int):Bool 
	{
		return left <= value && value < right;
	}
}

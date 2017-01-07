package litll.core.ds;

class LinePosition 
{
	public var innerIndex:Int;
	public var outerIndex:Int;
	public var outerLine:Int;
	public var padding:Int;
	
	public function new (innerPosition:Int, outerPosition:Int, outerLine:Int, padding:Int)
	{
		this.outerLine = outerLine;
		this.padding = padding;
		this.innerIndex = innerPosition;
		this.outerIndex = outerPosition;
	}
}

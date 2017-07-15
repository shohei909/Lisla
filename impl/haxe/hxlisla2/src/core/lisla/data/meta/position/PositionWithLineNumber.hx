package lisla.data.meta.position;

class PositionWithLineNumber 
{	
    public var inlineIndex:CodePointIndex;
    public var lineNumber:Int;
    
	public function new (lineNumber:Int, inlineIndex:CodePointIndex)
	{
        this.lineNumber = lineNumber;
        this.inlineIndex = inlineIndex;
    }
}

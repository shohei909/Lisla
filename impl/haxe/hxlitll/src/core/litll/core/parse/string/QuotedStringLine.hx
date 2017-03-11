package lisla.core.parse.string;

class QuotedStringLine
{
	public var startPosition:Int;
	public var content:String;
	public var indent:Int;
	public var newLine:String;
	
	public function isWhite():Bool
	{
		return content.length == indent;
	}
	
	public inline function new(startPosition:Int) 
	{
		this.startPosition = startPosition;
		
        newLine = "";
		content = "";
		indent = 0;
	}
}

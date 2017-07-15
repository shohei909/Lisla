package lisla.parse.string;
import lisla.data.meta.position.CodePointIndex;

class QuotedStringLine
{
	public var startPosition:CodePointIndex;
	public var content:String;
	public var indent:Int;
	public var newLine:String;
	
	public function isWhite():Bool
	{
		return content.length == indent;
	}
	
	public inline function new(startPosition:CodePointIndex) 
	{
		this.startPosition = startPosition;
		
        newLine = "";
		content = "";
		indent = 0;
	}
}

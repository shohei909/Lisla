package litll.core.ds;

class SourcePosition
{
	public var line(default, null):Int;
	public var row(default, null):Int;
	public var index(default, null):Int;
	
	public function new(line:Int, row:Int, index:Int) 
	{
		this.line = line;
		this.row = row;
		this.index = index;
		
	}
	
	public inline function toString():String
	{
		return "line:" + line + ":" + row + "(" + index + ")";
	}
}
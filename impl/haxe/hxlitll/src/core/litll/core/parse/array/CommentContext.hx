package litll.core.parse.array;
import litll.core.char.CodePointTools;
import litll.core.parse.ParseContext;
import unifill.CodePoint;

class CommentContext
{
    private var parent:ArrayContext;
    private var top:ParseContext;
	private var keeping:Bool;
	private var state:CommentState;
	private var kind:CommentKind;
    
	public inline function new (top:ParseContext, parent:ArrayContext, kind:CommentKind)
	{
		this.top = top;
        this.parent = parent;
        this.kind = kind;
		this.keeping = false;
		this.state = CommentState.Head;
	}
    
	public inline function process(codePoint:CodePoint):Void
	{
		switch [codePoint.toInt(), state]
		{
			case [CodePointTools.EXCLAMATION, CommentState.Head]:
				keeping = true;
				state = CommentState.Body;
			
			case [_, CommentState.Head]:
				state = CommentState.Body;
				process(codePoint);
				
			case [CodePointTools.LF, CommentState.CarriageReturn | CommentState.Body]:
				writeComment(codePoint);
				end();
			
			case [_, CommentState.CarriageReturn]:
				end();
				parent.process(codePoint);
			
			case [CodePointTools.CR, CommentState.Body]:
				writeComment(codePoint);
				state = CommentState.CarriageReturn;
			
			case [_, CommentState.Body]:
				writeComment(codePoint);
		}
	}
    
	public inline function end():Void
	{
		switch (kind)
		{
			case CommentKind.Document:
				parent.state = ArrayState.Normal(true);
			
			case CommentKind.Normal:
				parent.state = ArrayState.Normal(true);
		}
	}
    
	private function writeComment(codePoint:CodePoint):Void
	{
		switch (kind)
		{
			case CommentKind.Normal:
				// TODO: format tag
				
			case CommentKind.Document:
                parent.writeDocument(codePoint);
		}
	}
}
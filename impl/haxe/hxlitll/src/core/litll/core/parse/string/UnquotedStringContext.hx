package litll.core.parse.string;
import litll.core.char.CodePointTools;
import litll.core.parse.ParseContext;
import litll.core.parse.array.ArrayState;
import litll.core.parse.array.ArrayContext;
import litll.core.parse.tag.UnsettledStringTag;
import unifill.CodePoint;

class UnquotedStringContext 
{
    private var top:ParseContext;
    private var parent:ArrayContext;
	private var string:String;
	private var state:UnquotedStringState;
	private var tag:UnsettledStringTag;
	
	public inline function new(top:ParseContext, parent:ArrayContext, tag:UnsettledStringTag) 
	{
		this.parent = parent;
        this.top = top;
        string = "";
		state = UnquotedStringState.Body(false);
		this.tag = tag;
	}
    
	public function process(codePoint:CodePoint):Void
	{
		switch [codePoint.toInt(), state]
		{
			// --------------------------
			// Slash
			// --------------------------
			case [CodePointTools.SLASH, UnquotedStringState.Body(true)]:
				state = UnquotedStringState.Body(false);
				end();
                parent.state = ArrayState.Slash(2);
			
			case [CodePointTools.SLASH, UnquotedStringState.Body(false)]:
				state = UnquotedStringState.Body(true);
				
			case [_, UnquotedStringState.Body(true)]:
				string += "/";
				state = UnquotedStringState.Body(false);
				process(codePoint);
				
			// --------------------------
			// EscapeSequence
			// --------------------------
			case [_, UnquotedStringState.EscapeSequence(escapeSequence)]:
				escapeSequence.process(codePoint, false).iter(
					function (unescapedCodePoint):Void
					{
						string += unescapedCodePoint.toString();
						state = UnquotedStringState.Body(false);
					}
				);
				
			case [CodePointTools.BACK_SLASH, UnquotedStringState.Body(false)]:
				state = UnquotedStringState.EscapeSequence(new EscapeSequenceContext(top));
				
			// --------------------------
			// Separater
			// --------------------------
			case [
					CodePointTools.CR | CodePointTools.LF | CodePointTools.SPACE | CodePointTools.TAB | 
					CodePointTools.CLOSEING_BRACKET | CodePointTools.OPENNING_BRACKET | 
					CodePointTools.DOUBLE_QUOTE | CodePointTools.SINGLE_QUOTE, 
					UnquotedStringState.Body(false)
				]:
				end();
				parent.process(codePoint);
			
			// --------------------------
			// Other, Normal
			// --------------------------
			case [_, UnquotedStringState.Body(false)]:
				if (CodePointTools.isBlackListedWhitespace(codePoint))
				{
					end();
					parent.process(codePoint);
				}
				else
				{
					string += codePoint.toString();
				}
		}
	}
    
	
	public function end():Void
	{
		switch (state)
		{
			case UnquotedStringState.Body(false):
				// do nothing.
			
			case UnquotedStringState.Body(true):
				string += "/";
				
			case UnquotedStringState.EscapeSequence(state):
				top.error(ParseErrorKind.InvalidEscapeSequence);
		}
		
		parent.pushString(new LitllString(string, tag.settle(top.position)));
	}
}

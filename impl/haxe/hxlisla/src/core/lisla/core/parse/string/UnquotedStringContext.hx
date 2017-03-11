package lisla.core.parse.string;
import lisla.core.char.CodePointTools;
import lisla.core.ds.SourceRange;
import lisla.core.parse.ParseContext;
import lisla.core.parse.array.ArrayState;
import lisla.core.parse.array.ArrayContext;
import lisla.core.parse.tag.UnsettledStringTag;
import unifill.CodePoint;

class UnquotedStringContext 
{
    private var top:ParseContext;
    private var parent:ArrayContext;
	private var string:String;
	private var tag:UnsettledStringTag;
	
	public inline function new(top:ParseContext, parent:ArrayContext, tag:UnsettledStringTag) 
	{
		this.parent = parent;
        this.top = top;
        string = "";
		this.tag = tag;
	}
    
	public function process(codePoint:CodePoint):Void
	{
		switch codePoint.toInt()
		{
			// --------------------------
			// Slash
			// --------------------------
			case CodePointTools.SEMICOLON:
				end();
                parent.state = ArrayState.Semicolon;
				
			case CodePointTools.BACK_SLASH:
				top.error(ParseErrorKind.UnquotedEscapeSequence, new SourceRange(top.sourceMap, tag.startPosition, top.position));
				
			// --------------------------
			// Separater
			// --------------------------
			case CodePointTools.CR | CodePointTools.LF | CodePointTools.SPACE | CodePointTools.TAB | 
                CodePointTools.CLOSEING_PAREN | CodePointTools.OPENNING_PAREN | 
                CodePointTools.DOUBLE_QUOTE | CodePointTools.SINGLE_QUOTE:
				end();
				parent.process(codePoint);
			
			// --------------------------
			// Other, Normal
			// --------------------------
			case _:
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
        parent.pushString(new LislaString(string, tag.settle(top.position)));
	}
}

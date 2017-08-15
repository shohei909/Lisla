package lisla.parse.string;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.error.parse.BasicParseErrorKind;
import lisla.parse.ParseContext;
import lisla.parse.array.ArrayContext;
import lisla.parse.array.ArrayState;
import lisla.parse.char.CodePointTools;
import lisla.parse.metadata.UnsettledStringTag;
import unifill.CodePoint;

class UnquotedStringContext 
{
    private var top:ParseContext;
    private var parent:ArrayContext;
	private var string:String;
	private var metadata:UnsettledStringTag;
	
	public inline function new(top:ParseContext, parent:ArrayContext, metadata:UnsettledStringTag) 
	{
		this.parent = parent;
        this.top = top;
        string = "";
		this.metadata = metadata;
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
				top.error(
                    BasicParseErrorKind.UnquotedEscapeSequence, 
                    Range.createWithEnd(metadata.startPosition, top.position)
                );
				
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
        parent.pushString(string, metadata.settle(top.position));
	}
}

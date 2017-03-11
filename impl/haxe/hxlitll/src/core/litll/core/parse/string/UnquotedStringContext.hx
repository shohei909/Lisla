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
	private var isSlash:Bool;
	private var tag:UnsettledStringTag;
	
	public inline function new(top:ParseContext, parent:ArrayContext, tag:UnsettledStringTag) 
	{
		this.parent = parent;
        this.top = top;
        string = "";
		isSlash = false;
		this.tag = tag;
	}
    
	public function process(codePoint:CodePoint):Void
	{
		switch [codePoint.toInt(), isSlash]
		{
			// --------------------------
			// Slash
			// --------------------------
			case [CodePointTools.SLASH, true]:
				isSlash = false;
				end();
                parent.state = ArrayState.Slash(2);
			
			case [CodePointTools.SLASH, false]:
				isSlash = true;
				
			case [_, true]:
				string += "/";
				isSlash = false;
				process(codePoint);
				
			case [CodePointTools.BACK_SLASH, _]:
				top.error(ParseErrorKind.UnquotedEscapeSequence, new SourceRange(top.sourceMap, tag.startPosition, top.position));
				
			// --------------------------
			// Separater
			// --------------------------
			case [
					CodePointTools.CR | CodePointTools.LF | CodePointTools.SPACE | CodePointTools.TAB | 
					CodePointTools.CLOSEING_BRACKET | CodePointTools.OPENNING_BRACKET | 
					CodePointTools.DOUBLE_QUOTE | CodePointTools.SINGLE_QUOTE, 
					false
				]:
				end();
				parent.process(codePoint);
			
			// --------------------------
			// Other, Normal
			// --------------------------
			case [_, false]:
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
		if (isSlash)
		{
			string += "/";
            isSlash = false;
		}
		
		parent.pushString(new LislaString(string, tag.settle(top.position)));
	}
}

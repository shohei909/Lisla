package arraytree.parse.string;
import haxe.ds.Option;
import arraytree.data.meta.position.Range;
import arraytree.error.parse.BasicParseErrorKind;
import arraytree.parse.ParseState;
import arraytree.parse.array.ArrayContext;
import arraytree.parse.array.ArrayState;
import arraytree.parse.char.CodePointTools;
import arraytree.parse.tag.UnsettledStringTag;
import unifill.CodePoint;

class UnquotedStringContext 
{
    private var top:ParseState;
    private var parent:ArrayContext;
	private var string:String;
	private var tag:UnsettledStringTag;
    private var isPlaceholder:Bool;
	
	public inline function new(top:ParseState, parent:ArrayContext, isPlaceholder:Bool, tag:UnsettledStringTag) 
	{
		this.isPlaceholder = isPlaceholder;
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
			// Semicolon
			// --------------------------
			case CodePointTools.SEMICOLON:
				end();
                parent.state = ArrayState.Semicolon;
				
			// --------------------------
			// Separater
			// --------------------------
			case CodePointTools.CR | CodePointTools.LF | CodePointTools.SPACE | CodePointTools.TAB | 
                CodePointTools.CLOSEING_PAREN | CodePointTools.OPENNING_PAREN | 
                CodePointTools.DOUBLE_QUOTE | CodePointTools.SINGLE_QUOTE | CodePointTools.DOLLAR:
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
        parent.pushString(
            string, 
            isPlaceholder, 
            tag.settle(
                top.context,
                top.codePointIndex,
                [Range.createWithEnd(tag.startPosition, top.codePointIndex)]
            )
        );
        parent.state = ArrayState.Normal(false);
	}
}

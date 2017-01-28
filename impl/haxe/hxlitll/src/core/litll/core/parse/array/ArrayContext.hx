package litll.core.parse.array;
import haxe.ds.Option;
import litll.core.LitllString;
import litll.core.ds.Result;
import litll.core.ds.SourceRange;
import litll.core.parse.string.QuotedStringContext;
import litll.core.parse.string.UnquotedStringContext;
import unifill.CodePoint;
import litll.core.parse.ParseContext;
import litll.core.parse.array.ArrayParent;
import litll.core.parse.array.ArrayParent;
import litll.core.parse.tag.UnsettledArrayTag;
import litll.core.parse.tag.UnsettledLeadingTag;
using litll.core.char.CodePointTools;

class ArrayContext
{
    private var parent:ArrayParent;
    private var data:Array<Litll>;
	private var tag:UnsettledArrayTag;
	private var elementTag:UnsettledLeadingTag;
    private var top:ParseContext;
    public var isInHead(default, null):Bool;
    
    public var state:ArrayState;
    
	public function new(top:ParseContext, parent:ArrayParent, state:ArrayState, isInHead:Bool, tag:UnsettledArrayTag) 
	{
        this.top = top;
        this.state = state;
        this.isInHead = isInHead;
        this.parent = parent;
    
		this.tag = tag;
		this.data = [];
		this.elementTag = new UnsettledLeadingTag(tag.leadingTag.sourceMap);
	}
	
	private inline function popTag():UnsettledLeadingTag
	{
		var oldTag = this.elementTag;
		this.elementTag = new UnsettledLeadingTag(tag.leadingTag.sourceMap);
		return oldTag;
	}
	
	private function popStringTag(position:Int) 
	{
		return popTag().toStringTag(position);
	}
	
	private function popArrayTag(position:Int) 
	{
		return popTag().toArrayTag(position);
	}
	
    
	public function process(codePoint:CodePoint):Void
	{
		switch [codePoint.toInt(), this.state] 
    	{
            case [_, ArrayState.OpeningQuote(singleQuoted, length)]:
                processOpeningQuote(codePoint, singleQuoted, length);
                
            case [_, ArrayState.Comment(context)]:
				context.process(codePoint);
                
			case [_, ArrayState.QuotedString(context)]:
				context.process(codePoint);
			
			case [_, ArrayState.UnquotedString(context)]:
				context.process(codePoint);

			// --------------------------
			// Slash
			// --------------------------
			case [CodePointTools.SLASH, ArrayState.Slash(2)]:
				state = ArrayState.Comment(new CommentContext(top, this, CommentKind.Document));
			
			case [CodePointTools.SLASH, ArrayState.Slash(length)]:
				state = ArrayState.Slash(length + 1);
				
			case [_, ArrayState.Slash(2)]:
				var commentDetail = new CommentContext(top, this, CommentKind.Normal);
				this.state = ArrayState.Comment(commentDetail);
				commentDetail.process(codePoint);
				
			case [_, ArrayState.Slash(1)]:
				var unquotedString = startUnquotedString(CodePoint.fromInt(CodePointTools.SLASH));
				top.current.process(codePoint);
				
			case [_, ArrayState.Slash(length)]:
				throw "invalid slash length: " + length;
				
			case [CodePointTools.SLASH, ArrayState.Normal(_)]:
				state = ArrayState.Slash(1);
				
			// --------------------------
			// Separater, Normal
			// --------------------------
			case [CodePointTools.CR | CodePointTools.LF | CodePointTools.SPACE | CodePointTools.TAB, ArrayState.Normal(_)]:
				state = ArrayState.Normal(true);
			
			// --------------------------
			// Bracket, Normal
			// --------------------------
			case [CodePointTools.OPENNING_BRACKET, ArrayState.Normal(_)]:
				startArray();
				
			case [CodePointTools.CLOSEING_BRACKET, ArrayState.Normal(_)]:
				switch (parent)
				{
                    case ArrayParent.Array(parentContext):
                        endArray(parentContext);
                        
                    case ArrayParent.QuotedString(array, string, storedArray):
                        endInterporation(array, string, storedArray);
                    
                    case ArrayParent.Top:
                        top.error(ParseErrorKind.TooManyClosingBracket);
				}
                
				state = ArrayState.Normal(true);
			
			// --------------------------
			// QuotedString, Normal
			// --------------------------
			case [CodePointTools.DOUBLE_QUOTE, ArrayState.Normal(separated)]:
				if (!separated)
				{
					top.error(ParseErrorKind.SeparatorRequired);
				}
				state = ArrayState.OpeningQuote(false, 1);
				
			case [CodePointTools.SINGLE_QUOTE, ArrayState.Normal(separated)]:
				if (!separated)
				{
					top.error(ParseErrorKind.SeparatorRequired);
				}
				state = ArrayState.OpeningQuote(true, 1);
				
			// --------------------------
			// Other, Normal
			// --------------------------
			case [_, ArrayState.Normal(separated)]:
				if (CodePointTools.isBlackListedWhitespace(codePoint))
				{
					top.error(ParseErrorKind.BlacklistedWhitespace(codePoint));
				}
				else
				{
					if (!separated)
					{
						top.error(ParseErrorKind.SeparatorRequired);
					}
					startUnquotedString(codePoint);
				}
		}
	}
    
	public inline function processOpeningQuote(codePoint:CodePoint, singleQuoted:Bool, length:Int):Void
	{
		switch [codePoint.toInt(), singleQuoted]
		{
			case [CodePointTools.SINGLE_QUOTE, true] | [CodePointTools.DOUBLE_QUOTE, false]:
				state = ArrayState.OpeningQuote(singleQuoted, length + 1);
				
			case _:
				endOpennigQuote(singleQuoted, length);
				top.current.process(codePoint);
		}
	}
    
    // =============================
	// Start
	// =============================
	private inline function startArray():Void 
	{
        var tag = popArrayTag(top.position - 1);
		state = ArrayState.Normal(true);
        var child = new ArrayContext(top, ArrayParent.Array(this), state, false, tag);
		top.current = child;
	}

	private inline function startUnquotedString(codePoint:CodePoint):Void
	{
		var stringContext = new UnquotedStringContext(top, this, popStringTag(top.position));
		state = ArrayState.UnquotedString(stringContext);
		
		stringContext.process(codePoint);
	}
	
	// =============================
	// end
	// =============================
	private inline function endOpennigQuote(singleQuoted:Bool, length:Int):Void
	{
		if (length == 2)
		{
			data.push(Litll.Str(new LitllString("", popStringTag(top.position - 2).settle(top.position))));
			state = ArrayState.Normal(false);
		}
		else
		{
			state = ArrayState.QuotedString(new QuotedStringContext(top, this, singleQuoted, length, popStringTag(top.position - length)));
		}
	}
    
    private function endArray(destination:ArrayContext):Void
	{
		var arr = new LitllArray<Litll>(data, tag.settle(top.position));
		
		destination.data.push(Litll.Arr(arr));
		top.current = destination;
	}
    
    private function endInterporation(arrayContext:ArrayContext, stringContext:QuotedStringContext, storedArray:Array<LitllArray<Litll>>):Void
    {
    	var arr = new LitllArray<Litll>(data, tag.settle(top.position));
        storedArray.push(arr);
		stringContext.store(storedArray);
        
		top.current = arrayContext;
    }
    
    public function pushString(litllString:LitllString):Void
    {
        data.push(Litll.Str(litllString));
		state = ArrayState.Normal(false);
    }
    
    public function writeDocument(codePoint:CodePoint):Void
    {
        var tag = if (isInHead) tag.leadingTag else elementTag;
        tag.writeDocument(top.config, codePoint, top.position - 1);
    }
    
	public inline function endTop():LitllArray<Litll>
	{
		return new LitllArray<Litll>(data, tag.settle(top.position));
	}
    
    public inline function getData():Option<LitllArray<Litll>> 
	{
		return switch (state)
        {
            case ArrayState.Slash(_):
                startUnquotedString(CodePoint.fromInt(CodePointTools.SLASH));
                Option.None;
                
            case ArrayState.Normal(_):
                switch (parent)
                {
                    case ArrayParent.Array(arrayContext):
                        top.error(ParseErrorKind.UnclosedArray, new SourceRange(top.sourceMap, tag.startPosition, tag.startPosition + 1));
                        endArray(arrayContext);
                        Option.None;
                        
                    case ArrayParent.QuotedString(arrayContext, stringContext, storedArray):
                        top.error(ParseErrorKind.UnclosedArray, new SourceRange(top.sourceMap, tag.startPosition, tag.startPosition + 1));
                        endInterporation(arrayContext, stringContext, storedArray);
                        Option.None;
                        
                    case ArrayParent.Top:
                        Option.Some(endTop());
                }
            
            case ArrayState.QuotedString(context):
                context.end();
                Option.None;
                        
            case ArrayState.UnquotedString(context):
                context.end();
                Option.None;
                        
            case ArrayState.OpeningQuote(singleQuoted, length):
                endOpennigQuote(singleQuoted, length);
                Option.None;
                
            case ArrayState.Comment(context):
                context.end();
                Option.None;
        }
	}
}

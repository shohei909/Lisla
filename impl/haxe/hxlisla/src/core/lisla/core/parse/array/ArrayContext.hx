package lisla.core.parse.array;
import haxe.ds.Option;
import lisla.core.LislaArray;
import lisla.core.LislaString;
import hxext.ds.Result;
import lisla.core.ds.SourceRange;
import lisla.core.parse.string.QuotedStringContext;
import lisla.core.parse.string.QuotedStringArrayPair;
import lisla.core.parse.string.UnquotedStringContext;
import unifill.CodePoint;
import lisla.core.parse.ParseContext;
import lisla.core.parse.array.ArrayParent;
import lisla.core.parse.array.ArrayParent;
import lisla.core.parse.tag.UnsettledArrayTag;
import lisla.core.parse.tag.UnsettledLeadingTag;
using lisla.core.char.CodePointTools;

class ArrayContext
{
    private var parent:ArrayParent;
    private var data:Array<Lisla>;
	private var tag:UnsettledArrayTag;
	private var elementTag:UnsettledLeadingTag;
    private var top:ParseContext;
    public var isInHead(default, null):Bool;
    
    public var state:ArrayState;
    
	public function new(top:ParseContext, parent:ArrayParent, isInHead:Bool, tag:UnsettledArrayTag) 
	{
        this.top = top;
        this.isInHead = isInHead;
        this.parent = parent;
        this.state = ArrayState.Normal;
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
			// Escape
			// --------------------------
			case [CodePointTools.CR | CodePointTools.LF | CodePointTools.SPACE | CodePointTools.TAB, ArrayState.Escape]:
                switch (parent)
                {
                    case ArrayParent.QuotedString(stringContext, store):
                        var arr = new LislaArray<Lisla>(data, tag.settle(top.position));
                        store.array.push(arr);
                        
                        var nextContext = new ArrayContext(top, this.parent, false, new UnsettledLeadingTag(top.sourceMap).toArrayTag(top.position));
                        top.current = nextContext;
                        
                    case ArrayParent.Array(_) | ArrayParent.Top:
                        top.error(ParseErrorKind.InvalidInterpolationSeparator, new SourceRange(top.sourceMap, tag.startPosition, top.position));
                        state = ArrayState.Normal;
				}
                
			case [_, ArrayState.Escape]:
				top.error(ParseErrorKind.UnquotedEscapeSequence, new SourceRange(top.sourceMap, tag.startPosition, top.position));
				state = ArrayState.Normal;
                
			case [CodePointTools.BACK_SLASH, ArrayState.Normal]:
                state = ArrayState.Escape;
                
			// --------------------------
			// Slash
			// --------------------------
			case [CodePointTools.SEMICOLON, ArrayState.Semicolon]:
				state = ArrayState.Comment(new CommentContext(top, this, CommentKind.Document));
				
			case [_, ArrayState.Semicolon]:
				var commentDetail = new CommentContext(top, this, CommentKind.Normal);
				this.state = ArrayState.Comment(commentDetail);
				commentDetail.process(codePoint);
				
			case [CodePointTools.SEMICOLON, ArrayState.Normal]:
				state = ArrayState.Semicolon;
				
			// --------------------------
			// Separater, Normal
			// --------------------------
			case [CodePointTools.CR | CodePointTools.LF | CodePointTools.SPACE | CodePointTools.TAB, ArrayState.Normal]:
				// nothing to do.
			
			// --------------------------
			// Bracket, Normal
			// --------------------------
			case [CodePointTools.OPENNING_PAREN, ArrayState.Normal]:
				startArray();
				
			case [CodePointTools.CLOSEING_PAREN, ArrayState.Normal]:
				switch (parent)
				{
                    case ArrayParent.Array(parentContext):
                        endArray(parentContext);
                        
                    case ArrayParent.QuotedString(stringContext, store):
                        endInterporation(stringContext, store);
                    
                    case ArrayParent.Top:
                        top.error(ParseErrorKind.TooManyClosingBracket);
				}
                
				state = ArrayState.Normal;
			
			// --------------------------
			// QuotedString, Normal
			// --------------------------
			case [CodePointTools.DOUBLE_QUOTE, ArrayState.Normal]:
				state = ArrayState.OpeningQuote(false, 1);
				
			case [CodePointTools.SINGLE_QUOTE, ArrayState.Normal]:
				state = ArrayState.OpeningQuote(true, 1);
				
			// --------------------------
			// Other, Normal
			// --------------------------
			case [_, ArrayState.Normal]:
				if (CodePointTools.isBlackListedWhitespace(codePoint))
				{
					top.error(ParseErrorKind.BlacklistedWhitespace(codePoint));
				}
				else
				{
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
        var child = new ArrayContext(top, ArrayParent.Array(this), false, tag);
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
			data.push(Lisla.Str(new LislaString("", popStringTag(top.position - 2).settle(top.position))));
			state = ArrayState.Normal;
		}
		else
		{
			state = ArrayState.QuotedString(new QuotedStringContext(top, this, singleQuoted, length, popStringTag(top.position - length)));
		}
	}
    
    private function endArray(destination:ArrayContext):Void
	{
		var arr = new LislaArray<Lisla>(data, tag.settle(top.position));
		
		destination.data.push(Lisla.Arr(arr));
		top.current = destination;
	}
    
    private function endInterporation(stringContext:QuotedStringContext, store:QuotedStringArrayPair):Void
    {
    	var arr = new LislaArray<Lisla>(data, tag.settle(top.position));
        store.array.push(arr);
		stringContext.store(store);
        
		top.current = stringContext.parent;
    }
    
    public function pushString(lislaString:LislaString):Void
    {
        data.push(Lisla.Str(lislaString));
		state = ArrayState.Normal;
    }
    public function pushArray(lisla:LislaArray<Lisla>):Void
    {
        data.push(Lisla.Arr(lisla));
		state = ArrayState.Normal;
    }
    
    public function writeDocument(codePoint:CodePoint):Void
    {
        var tag = if (isInHead) tag.leadingTag else elementTag;
        tag.writeDocument(top.config, codePoint, top.position - 1);
    }
    
	public inline function endTop():LislaArray<Lisla>
	{
		return new LislaArray<Lisla>(data, tag.settle(top.position));
	}
    
    public inline function getData():Option<LislaArray<Lisla>> 
	{
		return switch (state)
        {
            case ArrayState.Semicolon:
                state = ArrayState.Normal;
                Option.None;
                
            case ArrayState.Normal:
                switch (parent)
                {
                    case ArrayParent.Array(arrayContext):
                        top.error(ParseErrorKind.UnclosedArray, new SourceRange(top.sourceMap, tag.startPosition, tag.startPosition + 1));
                        endArray(arrayContext);
                        Option.None;
                        
                    case ArrayParent.QuotedString(stringContext, store):
                        top.error(ParseErrorKind.UnclosedArray, new SourceRange(top.sourceMap, tag.startPosition, tag.startPosition + 1));
                        endInterporation(stringContext, store);
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
                
            case ArrayState.Escape:
				top.error(ParseErrorKind.UnquotedEscapeSequence, new SourceRange(top.sourceMap, tag.startPosition, top.position));
                state = ArrayState.Normal;
                Option.None;
        }
	}
}

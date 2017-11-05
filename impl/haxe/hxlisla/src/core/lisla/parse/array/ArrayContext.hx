package lisla.parse.array;
import haxe.ds.Option;
import lisla.data.leaf.template.Placeholder;
import lisla.data.leaf.template.TemplateLeaf;
import lisla.data.meta.core.Tag;
import lisla.data.meta.core.WithTag;
import lisla.data.meta.position.CodePointIndex;
import lisla.data.meta.position.Range;
import lisla.data.tree.array.ArrayTree;
import lisla.data.tree.array.ArrayTreeArray;
import lisla.error.parse.BasicParseErrorKind;
import lisla.parse.ParseState;
import lisla.parse.array.ArrayParent;
import lisla.parse.string.QuotedStringArrayPair;
import lisla.parse.string.QuotedStringContext;
import lisla.parse.string.UnquotedStringContext;
import lisla.parse.tag.UnsettledArrayTag;
import lisla.parse.tag.UnsettledLeadingTag;
import unifill.CodePoint;
using lisla.parse.char.CodePointTools;

class ArrayContext
{
    private var parent:ArrayParent;
    private var data:Array<WithTag<ArrayTree<TemplateLeaf>>>;
	private var tag:UnsettledArrayTag;
	private var elementTag:UnsettledLeadingTag;
    private var top:ParseState;
    
    public var state:ArrayState;
    
	public function new(top:ParseState, parent:ArrayParent, tag:UnsettledArrayTag) 
	{
        this.top = top;
        this.parent = parent;
        this.state = ArrayState.Normal(true);
		this.tag = tag;
		this.data = [];
		this.elementTag = new UnsettledLeadingTag();
	}
	
	private inline function popTag():UnsettledLeadingTag
	{
		var oldTag = this.elementTag;
		this.elementTag = new UnsettledLeadingTag();
		return oldTag;
	}
	
	private function popStringTag(position:CodePointIndex) 
	{
		return popTag().toStringTag(position);
	}
	
	private function popArrayTag(position:CodePointIndex) 
	{
		return popTag().toArrayTag(false, position);
	}
	
    
	public function process(codePoint:CodePoint):Void
	{
		switch [codePoint.toInt(), this.state] 
    	{
            case [_, ArrayState.OpeningQuote(singleQuoted, isPlaceholder, length)]:
                processOpeningQuote(codePoint, singleQuoted, isPlaceholder, length);
                
            case [_, ArrayState.Comment(context)]:
				context.process(codePoint);
                
			case [_, ArrayState.QuotedString(context)]:
				context.process(codePoint);
			
			case [_, ArrayState.UnquotedString(context)]:
				context.process(codePoint);

			// --------------------------
			// Semicolon
			// --------------------------
			case [CodePointTools.SEMICOLON, ArrayState.Semicolon]:
				state = ArrayState.Comment(new CommentContext(top, this, CommentKind.Document));
				
			case [_, ArrayState.Semicolon]:
				var commentDetail = new CommentContext(top, this, CommentKind.Normal);
				this.state = ArrayState.Comment(commentDetail);
				commentDetail.process(codePoint);
				
			case [CodePointTools.SEMICOLON, ArrayState.Normal(_)]:
				state = ArrayState.Semicolon;
				
			// --------------------------
			// Separater, Normal
			// --------------------------
			case [CodePointTools.CR | CodePointTools.LF | CodePointTools.SPACE | CodePointTools.TAB, ArrayState.Normal(_)]:
                state = ArrayState.Normal(true);
			
			// --------------------------
			// Bracket, Normal
			// --------------------------
			case [CodePointTools.OPENNING_PAREN, ArrayState.Normal(_)]:
				startArray();
				
			case [CodePointTools.CLOSEING_PAREN, ArrayState.Normal(_)]:
				switch (parent)
				{
                    case ArrayParent.Array(parentContext):
                        endArray(parentContext);
                        
                    case ArrayParent.Top:
                        top.errorWithCurrentPosition(BasicParseErrorKind.TooManyClosingBracket);
				}
                
				state = ArrayState.Normal(true);
			
			// --------------------------
			// QuotedString, Normal
			// --------------------------
			case [CodePointTools.DOUBLE_QUOTE, ArrayState.Normal(separated)]:
                if (!separated) top.error(BasicParseErrorKind.SeparaterRequired, top.getCurrentRange());
				state = ArrayState.OpeningQuote(false, false, 1);
				
			case [CodePointTools.SINGLE_QUOTE, ArrayState.Normal(separated)]:
                if (!separated) top.error(BasicParseErrorKind.SeparaterRequired, top.getCurrentRange());
				state = ArrayState.OpeningQuote(true, false, 1);
				
			// --------------------------
			// Dollar
			// --------------------------
			case [CodePointTools.AT, ArrayState.Normal(separated)]:
                if (!separated) top.error(BasicParseErrorKind.SeparaterRequired, top.getCurrentRange());
				state = ArrayState.Dollar;
				
			case [CodePointTools.DOUBLE_QUOTE, ArrayState.Dollar]:
				state = ArrayState.OpeningQuote(false, true, 1);
				
			case [CodePointTools.SINGLE_QUOTE, ArrayState.Dollar]:
				state = ArrayState.OpeningQuote(true, true, 1);
                
            case [
                CodePointTools.CR | CodePointTools.LF | CodePointTools.SPACE | CodePointTools.TAB | CodePointTools.CLOSEING_PAREN | CodePointTools.OPENNING_PAREN | CodePointTools.SEMICOLON | CodePointTools.AT,
                ArrayState.Dollar
            ]:
                top.error(BasicParseErrorKind.EmptyPlaceholder, top.getCurrentRange());
                state = ArrayState.Normal(false);
                process(codePoint);
                
			case [_, ArrayState.Dollar]:
                startUnquotedString(codePoint, true);
			// --------------------------
			// Other, Normal
			// --------------------------
			case [_, ArrayState.Normal(separated)]:
                if (!separated) top.error(BasicParseErrorKind.SeparaterRequired, top.getCurrentRange());
				startUnquotedString(codePoint, false);
		}
	}
    
	public inline function processOpeningQuote(codePoint:CodePoint, singleQuoted:Bool, isPlaceholder:Bool, length:Int):Void
	{
		switch [codePoint.toInt(), singleQuoted]
		{
			case [CodePointTools.SINGLE_QUOTE, true] | [CodePointTools.DOUBLE_QUOTE, false]:
				state = ArrayState.OpeningQuote(singleQuoted, isPlaceholder, length + 1);
				
			case _:
				endOpennigQuote(singleQuoted, isPlaceholder, length);
				top.current.process(codePoint);
		}
	}
    
    // =============================
	// Start
	// =============================
	private inline function startArray():Void 
	{
        var tag = popArrayTag(top.codePointIndex - 1);
        var child = new ArrayContext(top, ArrayParent.Array(this), tag);
		top.current = child;
	}

	private inline function startUnquotedString(codePoint:CodePoint, isPlaceholder:Bool):Void
	{
        if (CodePointTools.isBlackListedWhitespace(codePoint))
        {
            return top.errorWithCurrentPosition(BasicParseErrorKind.BlacklistedWhitespace(codePoint));
        }
        
		var stringContext = new UnquotedStringContext(top, this, isPlaceholder, popStringTag(top.codePointIndex));
		state = ArrayState.UnquotedString(stringContext);
		
		stringContext.process(codePoint);
	}
	
	// =============================
	// end
	// =============================
	private inline function endOpennigQuote(singleQuoted:Bool, isPlaceholder:Bool, length:Int):Void
	{
		if (length == 2)
		{
            var tag = popStringTag(top.codePointIndex - 2).settle(
                top.context, 
                top.codePointIndex, 
                [top.getCurrentRange()]
            );
            pushString("", isPlaceholder, tag);
		}
		else
		{
			state = ArrayState.QuotedString(new QuotedStringContext(top, this, singleQuoted, isPlaceholder, length, popStringTag(top.codePointIndex - length)));
		}
	}
    
    private function endArray(destination:ArrayContext):Void
	{
        var tag = tag.settle(top.context, top.codePointIndex, elementTag);
		destination.pushArray(data, tag);
		top.current = destination;
	}
    
    public function push(tree:WithTag<ArrayTree<TemplateLeaf>>, separated:Bool):Void
    {
        data.push(tree);
		state = ArrayState.Normal(separated);
    }
    
    public function pushString(string:String, isPlaceholder:Bool, tag:Tag):Void
    {
        var kind = if (isPlaceholder)
        {
            TemplateLeaf.Placeholder(new Placeholder(string));
        }
        else
        {
            TemplateLeaf.Str(string);
        }
        push(new WithTag(ArrayTree.Leaf(kind), tag), false);
    }
    
    public function pushArray(trees:ArrayTreeArray<TemplateLeaf>, tag:Tag):Void
    {
        var kind = ArrayTree.Arr(trees);
        push(new WithTag(kind, tag), true);
    }
    
    public function writeDocument(codePoint:CodePoint):Void
    {
        var tag = elementTag;
        tag.writeDocument(top.config, codePoint, top.codePointIndex - 1);
    }
    
	public inline function endTop():{trees:ArrayTreeArray<TemplateLeaf>, tag:Tag}
	{
		return {
            trees: data, 
            tag: tag.settle(top.context, top.codePointIndex, elementTag)
        }
	}
    
    public inline function getData():Option<{trees:ArrayTreeArray<TemplateLeaf>, tag:Tag}> 
	{
		return switch (state)
        {
            case ArrayState.Semicolon:
                state = ArrayState.Normal(true);
                Option.None;
                
            case ArrayState.Normal(_):
                switch (parent)
                {
                    case ArrayParent.Array(arrayContext):
                        top.error(BasicParseErrorKind.UnclosedArray, Range.createWithLength(tag.startPosition, 1));
                        endArray(arrayContext);
                        Option.None;
                        
                    case ArrayParent.Top:
                        Option.Some(endTop());
                }
                
            case ArrayState.Dollar:
                top.error(BasicParseErrorKind.EmptyPlaceholder, top.getCurrentRange());
                state = ArrayState.Normal(false);
                Option.None;
                
            case ArrayState.QuotedString(context):
                context.end();
                Option.None;
                        
            case ArrayState.UnquotedString(context):
                context.end();
                Option.None;
                        
            case ArrayState.OpeningQuote(singleQuoted, isPlaceholder, length):
                endOpennigQuote(singleQuoted, isPlaceholder, length);
                Option.None;
                
            case ArrayState.Comment(context):
                context.end();
                Option.None;
        }
	}
}

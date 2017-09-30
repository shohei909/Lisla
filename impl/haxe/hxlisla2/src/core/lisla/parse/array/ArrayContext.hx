package lisla.parse.array;
import haxe.ds.Option;
import lisla.data.leaf.template.Placeholder;
import lisla.data.leaf.template.TemplateLeaf;
import lisla.data.meta.core.Metadata;
import lisla.data.meta.position.CodePointIndex;
import lisla.data.meta.position.Range;
import lisla.data.tree.array.ArrayTree;
import lisla.data.tree.array.ArrayTreeKind;
import lisla.error.parse.BasicParseErrorKind;
import lisla.parse.ParseContext;
import lisla.parse.array.ArrayParent;
import lisla.parse.string.QuotedStringArrayPair;
import lisla.parse.string.QuotedStringContext;
import lisla.parse.string.UnquotedStringContext;
import lisla.parse.metadata.UnsettledArrayTag;
import lisla.parse.metadata.UnsettledLeadingTag;
import unifill.CodePoint;
using lisla.parse.char.CodePointTools;

class ArrayContext
{
    private var parent:ArrayParent;
    private var data:Array<ArrayTree<TemplateLeaf>>;
	private var metadata:UnsettledArrayTag;
	private var elementTag:UnsettledLeadingTag;
    private var top:ParseContext;
    
    public var state:ArrayState;
    
	public function new(top:ParseContext, parent:ArrayParent, metadata:UnsettledArrayTag) 
	{
        this.top = top;
        this.parent = parent;
        this.state = ArrayState.Normal(true);
		this.metadata = metadata;
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
		return popTag().toArrayTag(position);
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
                if (!separated) top.error(BasicParseErrorKind.SeparaterRequired, Range.createWithLength(top.position - 1, 1));
				state = ArrayState.OpeningQuote(false, false, 1);
				
			case [CodePointTools.SINGLE_QUOTE, ArrayState.Normal(separated)]:
                if (!separated) top.error(BasicParseErrorKind.SeparaterRequired, Range.createWithLength(top.position - 1, 1));
				state = ArrayState.OpeningQuote(true, false, 1);
				
			// --------------------------
			// Dollar
			// --------------------------
			case [CodePointTools.DOLLAR, ArrayState.Normal(separated)]:
                if (!separated) top.error(BasicParseErrorKind.SeparaterRequired, Range.createWithLength(top.position - 1, 1));
				state = ArrayState.Dollar;
				
			case [CodePointTools.DOUBLE_QUOTE, ArrayState.Dollar]:
				state = ArrayState.OpeningQuote(false, true, 1);
				
			case [CodePointTools.SINGLE_QUOTE, ArrayState.Dollar]:
				state = ArrayState.OpeningQuote(true, true, 1);
                
            case [
                CodePointTools.CR | CodePointTools.LF | CodePointTools.SPACE | CodePointTools.TAB | CodePointTools.CLOSEING_PAREN | CodePointTools.OPENNING_PAREN | CodePointTools.SEMICOLON | CodePointTools.DOLLAR,
                ArrayState.Dollar
            ]:
                top.error(BasicParseErrorKind.EmptyPlaceholder, Range.createWithLength(top.position - 1, 1));
                state = ArrayState.Normal(false);
                process(codePoint);
                
			case [_, ArrayState.Dollar]:
                startUnquotedString(codePoint, true);
			// --------------------------
			// Other, Normal
			// --------------------------
			case [_, ArrayState.Normal(separated)]:
                if (!separated) top.error(BasicParseErrorKind.SeparaterRequired, Range.createWithLength(top.position - 1, 1));
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
        var metadata = popArrayTag(top.position - 1);
        var child = new ArrayContext(top, ArrayParent.Array(this), metadata);
		top.current = child;
	}

	private inline function startUnquotedString(codePoint:CodePoint, isPlaceholder:Bool):Void
	{
        if (CodePointTools.isBlackListedWhitespace(codePoint))
        {
            return top.errorWithCurrentPosition(BasicParseErrorKind.BlacklistedWhitespace(codePoint));
        }
        
		var stringContext = new UnquotedStringContext(top, this, isPlaceholder, popStringTag(top.position));
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
            pushString("", isPlaceholder, popStringTag(top.position - 2).settle(top.position));
		}
		else
		{
			state = ArrayState.QuotedString(new QuotedStringContext(top, this, singleQuoted, isPlaceholder, length, popStringTag(top.position - length)));
		}
	}
    
    private function endArray(destination:ArrayContext):Void
	{
		destination.pushArray(data, metadata.settle(top.position, elementTag));
		top.current = destination;
	}
    
    public function push(tree:ArrayTree<TemplateLeaf>, separated:Bool):Void
    {
        data.push(tree);
		state = ArrayState.Normal(separated);
    }
    
    public function pushString(string:String, isPlaceholder:Bool, metadata:Metadata):Void
    {
        var kind = if (isPlaceholder)
        {
            TemplateLeaf.Placeholder(new Placeholder(string));
        }
        else
        {
            TemplateLeaf.Str(string);
        }
        push(new ArrayTree(ArrayTreeKind.Leaf(kind), metadata), false);
    }
    
    public function pushArray(trees:Array<ArrayTree<TemplateLeaf>>, metadata:Metadata):Void
    {
        var kind = ArrayTreeKind.Arr(trees);
        push(new ArrayTree(kind, metadata), true);
    }
    
    public function writeDocument(codePoint:CodePoint):Void
    {
        var metadata = elementTag;
        metadata.writeDocument(top.config, codePoint, top.position - 1);
    }
    
	public inline function endTop():{trees:Array<ArrayTree<TemplateLeaf>>, metadata:Metadata}
	{
        var kind = ArrayTreeKind.Arr(data);
		return {
            trees: data, 
            metadata: metadata.settle(top.position, elementTag)
        }
	}
    
    public inline function getData():Option<{trees:Array<ArrayTree<TemplateLeaf>>, metadata:Metadata}> 
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
                        top.error(BasicParseErrorKind.UnclosedArray, Range.createWithLength(metadata.startPosition, 1));
                        endArray(arrayContext);
                        Option.None;
                        
                    case ArrayParent.Top:
                        Option.Some(endTop());
                }
                
            case ArrayState.Dollar:
                top.error(BasicParseErrorKind.EmptyPlaceholder, Range.createWithLength(top.position - 1, 1));
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

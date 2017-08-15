package lisla.parse.array;
import haxe.ds.Option;
import lisla.data.leaf.template.TemplateLeaf;
import lisla.data.meta.core.Metadata;
import lisla.data.meta.position.CodePointIndex;
import lisla.data.meta.position.Range;
import lisla.data.tree.al.AlTree;
import lisla.data.tree.al.AlTreeKind;
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
    private var data:Array<AlTree<TemplateLeaf>>;
	private var metadata:UnsettledArrayTag;
	private var elementTag:UnsettledLeadingTag;
    private var top:ParseContext;
    
    public var state:ArrayState;
    
	public function new(top:ParseContext, parent:ArrayParent, metadata:UnsettledArrayTag) 
	{
        this.top = top;
        this.parent = parent;
        this.state = ArrayState.Normal;
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
                        store.pushArray(data, metadata.settle(top.position, elementTag));
                        
                        var nextContext = new ArrayContext(top, this.parent, new UnsettledLeadingTag().toArrayTag(top.position));
                        top.current = nextContext;
                        
                    case ArrayParent.Array(_) | ArrayParent.Top:
                        top.error(BasicParseErrorKind.InvalidInterpolationSeparator, Range.createWithEnd(metadata.startPosition, top.position));
                        state = ArrayState.Normal;
				}
                
			case [_, ArrayState.Escape]:
				top.error(BasicParseErrorKind.UnquotedEscapeSequence, Range.createWithEnd(metadata.startPosition, top.position));
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
                        top.errorWithCurrentPosition(BasicParseErrorKind.TooManyClosingBracket);
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
					top.errorWithCurrentPosition(BasicParseErrorKind.BlacklistedWhitespace(codePoint));
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
        var metadata = popArrayTag(top.position - 1);
        var child = new ArrayContext(top, ArrayParent.Array(this), metadata);
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
            pushString("", popStringTag(top.position - 2).settle(top.position));
		}
		else
		{
			state = ArrayState.QuotedString(new QuotedStringContext(top, this, singleQuoted, length, popStringTag(top.position - length)));
		}
	}
    
    private function endArray(destination:ArrayContext):Void
	{
		destination.pushArray(data, metadata.settle(top.position, elementTag));
		top.current = destination;
	}
    
    private function endInterporation(stringContext:QuotedStringContext, store:QuotedStringArrayPair):Void
    {
        store.pushArray(data, metadata.settle(top.position, elementTag));
		stringContext.store(store);
        
		top.current = stringContext.parent;
    }
    
    public function push(tree:AlTree<TemplateLeaf>):Void
    {
        data.push(tree);
		state = ArrayState.Normal;
    }
    
    public function pushString(string:String, metadata:Metadata):Void
    {
        var kind = AlTreeKind.Leaf(TemplateLeaf.Str(string));
        push(new AlTree(kind, metadata));
    }
    
    public function pushArray(trees:Array<AlTree<TemplateLeaf>>, metadata:Metadata):Void
    {
        var kind = AlTreeKind.Arr(trees);
        push(new AlTree(kind, metadata));
    }
    
    public function writeDocument(codePoint:CodePoint):Void
    {
        var metadata = elementTag;
        metadata.writeDocument(top.config, codePoint, top.position - 1);
    }
    
	public inline function endTop():{trees:Array<AlTree<TemplateLeaf>>, metadata:Metadata}
	{
        var kind = AlTreeKind.Arr(data);
		return {
            trees: data, 
            metadata: metadata.settle(top.position, elementTag)
        }
	}
    
    public inline function getData():Option<{trees:Array<AlTree<TemplateLeaf>>, metadata:Metadata}> 
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
                        top.error(BasicParseErrorKind.UnclosedArray, Range.createWithLength(metadata.startPosition, 1));
                        endArray(arrayContext);
                        Option.None;
                        
                    case ArrayParent.QuotedString(stringContext, store):
                        top.error(BasicParseErrorKind.UnclosedArray, Range.createWithLength(metadata.startPosition, 1));
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
				top.error(BasicParseErrorKind.UnquotedEscapeSequence, Range.createWithEnd(metadata.startPosition, top.position));
                state = ArrayState.Normal;
                Option.None;
        }
	}
}

package lisla.parse.array;
import haxe.ds.Option;
import lisla.data.leaf.template.TemplateLeaf;
import lisla.data.meta.core.Metadata;
import lisla.data.meta.position.CodePointIndex;
import lisla.data.meta.position.Range;
import lisla.data.tree.array.ArrayTree;
import lisla.data.tree.array.ArrayTreeKind;
import lisla.error.parse.BasicParseErrorKind;
import lisla.parse.ParseContext;
import lisla.parse.array.ArrayParent;
import lisla.parse.string.QuotedStringContext;
import lisla.parse.string.UnquotedStringContext;
import lisla.parse.tag.UnsettledArrayTag;
import lisla.parse.tag.UnsettledLeadingTag;
import unifill.CodePoint;
using lisla.parse.char.CodePointTools;

class ArrayContext
{
    private var parent:ArrayParent;
    private var data:Array<ArrayTree<TemplateLeaf>>;
	private var tag:UnsettledArrayTag;
	private var elementTag:UnsettledLeadingTag;
    private var top:ParseContext;
    
    public var state:ArrayState;
    
	public function new(top:ParseContext, parent:ArrayParent, tag:UnsettledArrayTag) 
	{
        this.top = top;
        this.parent = parent;
        this.state = ArrayState.Normal;
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
                top.error(BasicParseErrorKind.InvalidInterpolationSeparator, Range.createWithEnd(tag.startPosition, top.position));
                state = ArrayState.Normal;
				
			case [_, ArrayState.Escape]:
				top.error(BasicParseErrorKind.UnquotedEscapeSequence, Range.createWithEnd(tag.startPosition, top.position));
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
                    
                    case ArrayParent.Top:
                        top.error(BasicParseErrorKind.TooManyClosingBracket);
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
					top.error(BasicParseErrorKind.BlacklistedWhitespace(codePoint));
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
        var child = new ArrayContext(top, ArrayParent.Array(this), tag);
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
		destination.pushArray(data, tag.settle(top.position, elementTag));
		top.current = destination;
	}
    
    public function push(tree:ArrayTree<TemplateLeaf>):Void
    {
        data.push(tree);
		state = ArrayState.Normal;
    }
    
    public function pushString(string:String, metadata:Metadata):Void
    {
        var kind = ArrayTreeKind.Leaf(TemplateLeaf.Str(string));
        push(new ArrayTree(kind, metadata));
    }
    
    public function pushArray(trees:Array<ArrayTree<TemplateLeaf>>, metadata:Metadata):Void
    {
        var kind = ArrayTreeKind.Arr(trees);
        push(new ArrayTree(kind, metadata));
    }
    
    public function writeDocument(codePoint:CodePoint):Void
    {
        var tag = elementTag;
        tag.writeDocument(top.config, codePoint, top.position - 1);
    }
    
	public inline function endTop():{trees:Array<ArrayTree<TemplateLeaf>>, metadata:Metadata}
	{
        var kind = ArrayTreeKind.Arr(data);
		return {
            trees: data, 
            metadata: tag.settle(top.position, elementTag)
        }
	}
    
    public inline function getData():Option<{trees:Array<ArrayTree<TemplateLeaf>>, metadata:Metadata}> 
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
                        top.error(BasicParseErrorKind.UnclosedArray, Range.createWithLength(tag.startPosition, 1));
                        endArray(arrayContext);
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
				top.error(BasicParseErrorKind.UnquotedEscapeSequence, Range.createWithEnd(tag.startPosition, top.position));
                state = ArrayState.Normal;
                Option.None;
        }
	}
}

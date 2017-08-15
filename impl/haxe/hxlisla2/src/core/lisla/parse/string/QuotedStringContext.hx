package lisla.parse.string;
using lisla.parse.char.CodePointTools;

import lisla.data.meta.core.Metadata;
import lisla.data.meta.position.CodePointIndex;
import lisla.data.meta.position.Range;
import lisla.data.tree.al.AlTree;
import lisla.data.tree.al.AlTreeKind;
import lisla.error.parse.BasicParseErrorKind;
import lisla.parse.ParseContext;
import lisla.parse.array.ArrayContext;
import lisla.parse.array.ArrayParent;
import lisla.parse.array.ArrayState;
import lisla.parse.metadata.UnsettledLeadingTag;
import lisla.parse.metadata.UnsettledStringTag;
import unifill.CodePoint;
import lisla.data.leaf.template.TemplateLeaf;

class QuotedStringContext 
{
    public var parent(default, null):ArrayContext;
    private var top:ParseContext;
    
	private var currentLine:QuotedStringLine;
    private var currentString:Array<QuotedStringLine>;
	private var storedData:Array<QuotedStringArrayPair>;
	
	private var state:QuotedStringState;
	private var singleQuoted:Bool;
	private var startQuoteCount:Int;
	private var metadata:UnsettledStringTag;
    
    private var lastIndent:String;
    
	public function new(top:ParseContext, parent:ArrayContext, singleQuoted:Bool, startQuoteCount:Int, metadata:UnsettledStringTag) 
	{
		this.top = top;
        this.parent = parent;
        this.singleQuoted = singleQuoted;
		this.startQuoteCount = startQuoteCount;
		this.metadata = metadata;
        this.currentString = [];
		this.storedData = [];
		this.currentLine = new QuotedStringLine(metadata.startPosition);
		this.state = QuotedStringState.Indent;
        
        this.lastIndent = "";
	}
	
    public function store(data:QuotedStringArrayPair):Void
    {
        metadata = new UnsettledLeadingTag().toStringTag(top.position);
        storedData.push(data);
    }
    
    public function process(codePoint:CodePoint):Void
	{
		switch (state) 
		{
			case QuotedStringState.EscapeSequence(context):
                switch (context.process(codePoint, true))
                {
					case EscapeResult.Letter(string):
                        currentLine.content += string;
						state = QuotedStringState.Body;
                        
					case EscapeResult.Interpolate:
                        currentString.push(currentLine);
                        var store = new QuotedStringArrayPair(currentString, metadata.settle(top.position));
                        
                        currentString = [];
                        this.currentLine = new QuotedStringLine(top.position);
                        state = QuotedStringState.Body;
                        
                        var arrayTag = new UnsettledLeadingTag().toArrayTag(top.position);
                        top.current = new ArrayContext(top, ArrayParent.QuotedString(this, store), arrayTag);
                        
					case EscapeResult.Continue:
                        // nothing to do.
				}
			
			case QuotedStringState.CarriageReturn:
				switch (codePoint.toInt())
				{
					case CodePointTools.LF:
						newLine("\r\n");
						
					case _:
						newLine("\r");
						process(codePoint);
				}
				
			case QuotedStringState.Quotes(length):
				if (matchQuote(codePoint))
				{
					state = QuotedStringState.Quotes(length + 1);
				}
				else
				{
					if (startQuoteCount <= length)
					{
						endClosedQuotedString(length);
						parent.process(codePoint);
					}
					else
					{
						addQuotes(length);
						state = QuotedStringState.Body;
						processBody(codePoint);
					}
				}
				
			case QuotedStringState.Indent:
				if (codePoint.isWhitespace())
				{
                    addIndent(codePoint);
				}
				else
				{
					state = QuotedStringState.Body;
					processBody(codePoint);
				}
				
			case QuotedStringState.Body:
				processBody(codePoint);
		}
	}
    
	private inline function processBody(codePoint:CodePoint):Void
	{
		if (matchQuote(codePoint))
		{
			state = QuotedStringState.Quotes(1);
		}
		else
		{
			switch (codePoint.toInt())
			{
				case CodePointTools.CR:
					state = QuotedStringState.CarriageReturn;
					
				case CodePointTools.LF:
					newLine("\n");
					
				case CodePointTools.BACK_SLASH if (!singleQuoted):
                    state = QuotedStringState.EscapeSequence(new EscapeSequenceContext(top));
					
				case _:
					currentLine.content += codePoint.toString();
			}
		}
	}

	private inline function addIndent(codePoint:CodePoint):Void
    {
        currentLine.content += codePoint.toString();
        lastIndent += codePoint.toString();
        currentLine.indent += 1;
    }
    
	private inline function newLine(string:String):Void 
	{
        lastIndent = "";
        
		currentLine.newLine = string;
		currentString.push(currentLine);
		currentLine = new QuotedStringLine(top.position);
		state = QuotedStringState.Indent;
	}
	
	private inline function matchQuote(codePoint:CodePoint):Bool
	{
		return switch [codePoint.toInt(), singleQuoted]
		{
			case [CodePointTools.SINGLE_QUOTE, true] | [CodePointTools.DOUBLE_QUOTE, false]:
				true;
				
			case _:
				false;
		}
	}
	
	private inline function addQuotes(length:Int):Void
	{
		var char = if (singleQuoted) CodePointTools.SINGLE_QUOTE else CodePointTools.DOUBLE_QUOTE;
		var string = String.fromCharCode(char);
		for (i in 0...length)
		{
			currentLine.content += string;
		}
	}
    
	public inline function end():Void
	{
		switch (state)
		{
			case CarriageReturn:
				newLine("\r");
				endUnclosedQuotedString(0);
				
			case Body | Indent:
				endUnclosedQuotedString(0);
				
			case Quotes(length):
				if (length < startQuoteCount)
				{
					endUnclosedQuotedString(length);
				}
				else
				{
					endClosedQuotedString(length);
				}
				
			case EscapeSequence(context):
				top.error(BasicParseErrorKind.InvalidEscapeSequence, Range.createWithEnd(metadata.startPosition, top.position));
		}
	}
	
	private function endUnclosedQuotedString(endQuoteCount:Int):Void
	{
		var startPosition = metadata.startPosition;
		top.error(BasicParseErrorKind.UnclosedQuote, Range.createWithEnd(metadata.startPosition - startQuoteCount, startPosition));
		parent.state = ArrayState.Normal;
	}
	
	private function endClosedQuotedString(endQuoteCount:Int):Void
	{
		if (endQuoteCount > startQuoteCount)
		{
			top.error(BasicParseErrorKind.TooManyClosingQuotes(startQuoteCount, endQuoteCount), Range.createWithEnd(top.position - endQuoteCount, top.position));
		}
		
        var isFirstGroup = true;
        var lastIndentSize = lastIndent.length;
        
        function addString(lines:Array<QuotedStringLine>, isLastGroup:Bool, metadata:Metadata):Void
        {
            var string = "";
            var isGroupTop = true;
            
            for (line in lines)
            {
                var isSkipTarget = lines.length > 1 && isFirstGroup && isGroupTop && line.isWhite();
                if (!isSkipTarget)
                {
                    if (isGroupTop)
                    {
                        string += line.content;
                    }
                    else
                    {
                        if (line.content.length == 0)
                        {
                            // nothing to do.
                        }
                        else if (line.content.substr(0, lastIndentSize) == lastIndent)
                        {
                            string += line.content.substr(lastIndentSize);
                        }
                        else
                        {
                            top.error(BasicParseErrorKind.UnmatchedIndentWhiteSpaces, Range.createWithLength(line.startPosition, lastIndentSize));
                            string += line.content;
                        }
                    }
                    string += line.newLine;
                }
                
                isGroupTop = false;
            }
            
            parent.pushString(string, metadata);
            isFirstGroup = false;
        }
        
        for (pair in storedData)
        {
            addString(pair.string, false, pair.metadata);
            
            for (tree in pair.trees)
            {
                parent.push(tree);
            }
        }
        
        if (currentString.length == 0 || !currentLine.isWhite())
        {
            currentString.push(currentLine);
        }
        else
        {
            currentString[currentString.length - 1].newLine = "";
        }
        
        addString(currentString, true, metadata.settle(top.position));
	}
}

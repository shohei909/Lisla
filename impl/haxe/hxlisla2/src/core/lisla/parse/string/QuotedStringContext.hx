package lisla.parse.string;
using lisla.parse.char.CodePointTools;

import String;
import lisla.data.meta.core.Metadata;
import lisla.data.meta.position.Range;
import lisla.error.parse.BasicParseErrorKind;
import lisla.parse.ParseContext;
import lisla.parse.array.ArrayContext;
import lisla.parse.array.ArrayParent;
import lisla.parse.array.ArrayState;
import lisla.parse.tag.UnsettledLeadingTag;
import lisla.parse.tag.UnsettledStringTag;
import unifill.CodePoint;

class QuotedStringContext 
{
    public var parent(default, null):ArrayContext;
    private var top:ParseContext;
    
	private var currentLine:QuotedStringLine;
    private var currentString:Array<QuotedStringLine>;
	private var state:QuotedStringState;
	private var singleQuoted:Bool;
	private var startQuoteCount:Int;
	private var tag:UnsettledStringTag;
    
    private var lastIndent:String;
    
	public function new(top:ParseContext, parent:ArrayContext, singleQuoted:Bool, startQuoteCount:Int, tag:UnsettledStringTag) 
	{
		this.top = top;
        this.parent = parent;
        this.singleQuoted = singleQuoted;
		this.startQuoteCount = startQuoteCount;
		this.tag = tag;
        this.currentString = [];
		this.currentLine = new QuotedStringLine(tag.startPosition);
		this.state = QuotedStringState.Indent;
        
        this.lastIndent = "";
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
				top.error(BasicParseErrorKind.InvalidEscapeSequence, Range.createWithEnd(tag.startPosition, top.position));
		}
	}
	
	private function endUnclosedQuotedString(endQuoteCount:Int):Void
	{
		var startPosition = tag.startPosition;
		top.error(BasicParseErrorKind.UnclosedQuote, Range.createWithEnd(tag.startPosition - startQuoteCount, startPosition));
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
        
        function addString(lines:Array<QuotedStringLine>, isLastGroup:Bool, tag:Metadata):Void
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
            
            parent.pushString(string, tag);
            isFirstGroup = false;
        }
        
        if (currentString.length == 0 || !currentLine.isWhite())
        {
            currentString.push(currentLine);
        }
        else
        {
            currentString[currentString.length - 1].newLine = "";
        }
        
        addString(currentString, true, tag.settle(top.position));
	}
}

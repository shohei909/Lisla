package litll.core.parse.string;
using litll.core.char.CodePointTools;
import litll.core.ds.SourceRange;
import litll.core.parse.ParseContext;
import litll.core.parse.array.ArrayContext;
import litll.core.parse.array.ArrayState;
import litll.core.parse.tag.UnsettledStringTag;
import unifill.CodePoint;

class QuotedStringContext 
{
    private var parent:ArrayContext;
    private var top:ParseContext;
	private var currentLine:QuotedStringLine;
    private var currentString:Array<QuotedStringLine>;
	private var storedData:Array<QuotedStringStoredData>;
	
	private var state:QuotedStringState;
	private var singleQuoted:Bool;
	private var startQuoteCount:Int;
	private var tag:UnsettledStringTag;
	
	public function new(top:ParseContext, parent:ArrayContext, singleQuoted:Bool, startQuoteCount:Int, tag:UnsettledStringTag) 
	{
		this.top = top;
        this.parent = parent;
        this.singleQuoted = singleQuoted;
		this.startQuoteCount = startQuoteCount;
		this.tag = tag;
        this.currentString = [];
		this.storedData = [];
		this.currentLine = new QuotedStringLine(tag.startPosition);
		this.state = QuotedStringState.Indent;
	}
	
    public function store(array:Array<LitllArray<Litll>>):Void
    {
        storedData.push(new QuotedStringStoredData(currentString, array));
        
		this.currentLine = new QuotedStringLine(top.position);
        currentString = [];
    }
    
    public function process(codePoint:CodePoint):Void
	{
		switch (state) 
		{
			case QuotedStringState.EscapeSequence(context):
                context.process(codePoint, true).iter(
					function (string)
					{
						currentLine.content += string;
						state = QuotedStringState.Body;
					}
				);
			
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
					currentLine.content += codePoint.toString();
					currentLine.indent += 1;
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
					
				case CodePointTools.BACK_SLASH if (!context.singleQuoted):
					state = QuotedStringState.EscapeSequence(new EscapeSequenceContext(position));
					
				case _:
					currentLine.content += codePoint.toString();
			}
		}
	}
	
	private inline function newLine(string:String):Void 
	{
		currentLine.newLine = string;
		currentString.push(currentLine);
		currentLine = new QuotedStringLine(top.position);
		state = QuotedStringState.Indent;
	}
    
    private inline function newString(array:Array<LitllArray<Litll>>):Void
    {
        currentString.push(currentLine);
        storedData.push(new QuotedStringStoredData(currentString, array));
        
        currentString = [];
        currentLine = new QuotedStringLine(top.position);
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
				top.error(ParseErrorKind.InvalidEscapeSequence, new SourceRange(top.sourceMap, startPosition, top.position));
		}
	}
	
	private function endUnclosedQuotedString(endQuoteCount:Int):Void
	{
		var startPosition = tag.startPosition;
		top.error(ParseErrorKind.UnclosedQuote, new SourceRange(top.sourceMap, startPosition - startQuoteCount, startPosition));
		parent.state = ArrayState.Normal(false);
	}
	
	private function endClosedQuotedString(endQuoteCount:Int):Void
	{
		if (endQuoteCount > startQuoteCount)
		{
			top.error(ParseErrorKind.TooManyClosingQuotes(startQuoteCount, endQuoteCount), new SourceRange(top.sourceMap, top.position - endQuoteCount, top.position));
		}
		
		var string = "";
		var lastLine = currentLine;
		var lastIndent = lastLine.indent;
		
		var iter = lines.iterator();
		if (iter.hasNext())
		{
			var firstLine = iter.next();
			if (!firstLine.isWhite())
			{
				string += firstLine.content + firstLine.newLine;
			}
			
			var whiteSpaces = lastLine.content.substr(0, lastIndent);
			
			for (line in iter)
			{
				if (line.content.length == 0)
				{
					string += line.newLine;
				}
				else if (line.indent < lastIndent)
				{
					top.error(ParseErrorKind.TooShortIndent, new SourceRange(top.sourceMap, line.startPosition, line.startPosition + line.indent));
				}
				else if (line.content.substr(0, lastIndent) != whiteSpaces)
				{
					top.error(ParseErrorKind.UnmatchedIndentWhiteSpaces, new SourceRange(top.sourceMap, line.startPosition, line.startPosition + lastIndent));
				}
				else
				{
					string += line.content.substr(lastIndent);
					if (iter.hasNext() || !lastLine.isWhite())
					{
						string += line.newLine;
					}
				}
			}
			
			string += lastLine.content.substr(lastIndent);
		}
		else
		{
			string = lastLine.content;
		}
		
		parent.pushString(new LitllString(string, tag.settle(top.position)));
	}
}

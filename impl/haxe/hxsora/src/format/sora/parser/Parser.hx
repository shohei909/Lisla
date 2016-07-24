package format.sora.parser;

import format.sora.char.NewLineChar;
import format.sora.data.Sora;
import format.sora.data.SoraArray;
import format.sora.data.SoraString;
import format.sora.tag.Range;
import format.sora.tag.Tag;
import haxe.ds.Option;
import haxe.io.StringInput;
import unifill.CodePoint;
import unifill.Exception;
import unifill.InternalEncoding;
using unifill.Unifill;
using format.sora.char.NewLineCharTools;
using format.sora.char.CodePointTools;

class Parser
{
	private var config:ParserConfig;
	private var position:Int;
	private var output:OutputArray;
	private var stack:Array<OutputArray>;
	private var errors:Array<ParseErrorEntry>;
	private var topContext:Context;
	
	public inline function new(config:ParserConfig) 
	{
		this.config = config;
		position = 0;
		errors = [];
		output = new OutputArray();
		stack = [];
		topContext = Context.Arr(ArrayContext.Normal(true, true));
	}
	
	public static function run(string:String, ?config:ParserConfig):SoraArray 
	{
		if (config == null) 
		{
			config = new ParserConfig();
		}
		
		var parser = new Parser(config);
		for (codePoint in string.uIterator())
		{
			parser.process(codePoint);
		}
		
		return parser.end();
	}
	
	
	// =============================
	// Process
	// =============================
	public inline function process(codePoint:CodePoint):Void
	{
		this.position += 1;
		
		switch (this.topContext)
		{
			case Arr(context):
				processArray(codePoint, context);
				
			case OpenningQuote(singleQuoted, length):
				processOpenningQuote(codePoint, singleQuoted, length);
				
			case QuotedString(detail):
				processQuotedString(codePoint, detail);
			
			case UnquotedString(detail):
				processUnquotedString(codePoint, detail);
				
			case Comment(context):
				processComment(codePoint, context);
		}
	}
	
	private function processArray(codePoint:CodePoint, context:ArrayContext):Void
	{
		switch [codePoint.toInt(), context] 
		{
			// --------------------------
			// Slash
			// --------------------------
			case [CodePointTools.SLASH, ArrayContext.Slash(isInHead, 2)]:
				topContext = Context.Comment(CommentContext.Document(isInHead));
			
			case [CodePointTools.SLASH, ArrayContext.Slash(isInHead, length)]:
				topContext = Context.Arr(ArrayContext.Slash(isInHead, length + 1));
				
			case [CodePointTools.EXCLAMATION, ArrayContext.Slash(isInHead, 2)]:
				topContext = Context.Comment(CommentContext.Keeping);
				
			case [_, ArrayContext.Slash(isInHead, 2)]:
				topContext = Context.Comment(CommentContext.Normal);
				process(codePoint);
				
			case [_, ArrayContext.Slash(isInHead, 1)]:
				startUnquotedString(CodePoint.fromInt(CodePointTools.SLASH));
				process(codePoint);
				
			case [_, ArrayContext.Slash(_, length)]:
				throw "invalid slash length: " + length;
				
			case [CodePointTools.SLASH, ArrayContext.Normal(isInHead, _)]:
				topContext = Context.Arr(Slash(isInHead, 1));
				
			// --------------------------
			// Separater, Normal
			// --------------------------
			case [CodePointTools.CR | CodePointTools.LF | CodePointTools.SPACE | CodePointTools.TAB, ArrayContext.Normal(_, _)]:
				topContext = Context.Arr(Normal(false, true));
			
			// --------------------------
			// Bracket, Normal
			// --------------------------
			case [CodePointTools.OPENNING_BRACKET, ArrayContext.Normal(_)]:
				startArray();
				
			case [CodePointTools.CLOSEING_BRACKET, ArrayContext.Normal(_)]:
				if (stack.length > 0)
				{
					endArray(stack.pop());
				}
				else
				{
					error(ParseErrorKind.TooManyClosingQuotes);
				}
				
				topContext = Context.Arr(Normal(false, true));
			
			// --------------------------
			// QuotedString, Normal
			// --------------------------
			case [CodePointTools.DOUBLE_QUOTE, ArrayContext.Normal(_, separated)]:
				if (!separated)
				{
					error(ParseErrorKind.SeparatorRequired);
				}
				topContext = Context.OpenningQuote(false, 0);
				
			case [CodePointTools.SINGLE_QUOTE, ArrayContext.Normal(_, separated)]:
				if (!separated)
				{
					error(ParseErrorKind.SeparatorRequired);
				}
				topContext = Context.OpenningQuote(true, 0);
				
			// --------------------------
			// Other, Normal
			// --------------------------
			case [_, ArrayContext.Normal(_, separated)]:
				if (CodePointTools.isBlackListedWhitespace(codePoint))
				{
					error(ParseErrorKind.BlacklistedWhitespace(codePoint));
				}
				else
				{
					startUnquotedString(codePoint);
				}
		}
	}
	
	private inline function processComment(codePoint:CodePoint, commentContext:CommentContext):Void
	{
		switch (commentContext)
		{
			case CommentContext.Normal:
				// TODO: format tag
				
			case CommentContext.Keeping:
				// TODO: format tag
				
			case CommentContext.Document(isInHead):
				if (isInHead)
				{
					output.footTag.writeDocument(config, codePoint, position - 1);
				}
		}
	}
	
	private inline function processOpenningQuote(codePoint:CodePoint, singleQuoted:Bool, length:Int):Void
	{
		switch [codePoint.toInt(), singleQuoted]
		{
			case [CodePointTools.SINGLE_QUOTE, true] | [CodePointTools.DOUBLE_QUOTE, false]:
				topContext = Context.OpenningQuote(singleQuoted, length + 1);
				
			case _:
				endOpennigQuote(singleQuoted, length);
				process(codePoint);
		}
	}
	
	private inline function processQuotedString(codePoint:CodePoint, detail:QuotedStringDetail):Void
	{
		switch (detail.context) 
		{
			case QuotedStringContext.EscapeSequence(escapeSequence):
				switch (processEscapeSequence(codePoint, escapeSequence))
				{
					case Option.Some(string):
						detail.currentLine.content += string;
						detail.context = QuotedStringContext.Body;
						
					case Option.None:
						// nothing to do
				}
			
			case QuotedStringContext.CarriageReturn:
				switch (codePoint.toInt())
				{
					case CodePointTools.LF:
						detail.newLine("\r\n", position);
						
					case _:
						detail.newLine("\r", position);
						processQuotedString(codePoint, detail);
				}
				
			case QuotedStringContext.Quotes(length):
				if (detail.matchQuote(codePoint))
				{
					detail.context = QuotedStringContext.Quotes(length + 1);
				}
				else
				{
					if (detail.quoteCount <= length)
					{
						endClosedQuotedString(length, detail);
					}
					else
					{
						detail.addQuotes(length);
						detail.context = QuotedStringContext.Body;
						processQuotedStringBody(codePoint, detail);
					}
				}
				
			case QuotedStringContext.Indent:
				if (codePoint.isWhitespace())
				{
					detail.currentLine.content += codePoint.toString();
					detail.currentLine.indent += 1;
				}
				else
				{
					detail.context = QuotedStringContext.Body;
					processQuotedStringBody(codePoint, detail);
				}
				
			case QuotedStringContext.Body:
				processQuotedStringBody(codePoint, detail);
		}
	}
	
	private inline function processQuotedStringBody(codePoint:CodePoint, detail:QuotedStringDetail):Void
	{
		if (detail.matchQuote(codePoint))
		{
			detail.context = QuotedStringContext.Quotes(1);
		}
		else
		{
			switch (codePoint.toInt())
			{
				case CodePointTools.CR:
					detail.context = QuotedStringContext.CarriageReturn;
					
				case CodePointTools.LF:
					detail.newLine("\n", position);
					
				case CodePointTools.BACK_SLASH if (!detail.singleQuoted):
					detail.context = QuotedStringContext.EscapeSequence(new EscapeSequenceDetail(position));
					
				case _:
					detail.currentLine.content += codePoint.toString();
			}
		}
	}
	
	private inline function processUnquotedString(codePoint:CodePoint, detail:UnquotedStringDetail):Void
	{
		switch [codePoint.toInt(), detail.context]
		{
			// --------------------------
			// Slash
			// --------------------------
			case [CodePointTools.SLASH, UnquotedStringContext.Body(true)]:
				detail.context = UnquotedStringContext.Body(false);
				endUnquotedString(detail);
				topContext = Context.Arr(Slash(false, 2));
			
			case [CodePointTools.SLASH, UnquotedStringContext.Body(false)]:
				detail.context = UnquotedStringContext.Body(true);
				
			case [_, UnquotedStringContext.Body(true)]:
				detail.string += "/";
				detail.context = UnquotedStringContext.Body(false);
				processUnquotedString(codePoint, detail);
				
			// --------------------------
			// EscapeSequence
			// --------------------------
			case [_, UnquotedStringContext.EscapeSequence(context)]:
				switch (processEscapeSequence(codePoint, context))
				{
					case Option.None:
						// do nothing.
					
					case Option.Some(unescapedCodePoint):
						detail.string += unescapedCodePoint.toString();
						detail.context = UnquotedStringContext.Body(false);
				}
				
			case [CodePointTools.BACK_SLASH, UnquotedStringContext.Body(false)]:
				detail.context = UnquotedStringContext.EscapeSequence(new EscapeSequenceDetail(position));
				
			// --------------------------
			// Separater
			// --------------------------
			case [
					CodePointTools.CR | CodePointTools.LF | CodePointTools.SPACE | CodePointTools.TAB | 
					CodePointTools.CLOSEING_BRACKET | CodePointTools.OPENNING_BRACKET | 
					CodePointTools.DOUBLE_QUOTE | CodePointTools.SINGLE_QUOTE, 
					UnquotedStringContext.Body(false)
				]:
				endUnquotedString(detail);
				process(codePoint);
			
			// --------------------------
			// Other, Normal
			// --------------------------
			case [_, UnquotedStringContext.Body(false)]:
				if (CodePointTools.isBlackListedWhitespace(codePoint))
				{
					endUnquotedString(detail);
					process(codePoint);
				}
				else
				{
					detail.string += codePoint.toString();
				}
		}
	}

	private inline function processEscapeSequence(codePoint:CodePoint, detail:EscapeSequenceDetail):Option<String>
	{
		var code = codePoint.toInt();
		
		return switch [code, detail.context]
		{
			case [CodePointTools.BACK_SLASH, EscapeSequenceContext.Head]:
				Option.Some("\\");
			
			case [CodePointTools.SINGLE_QUOTE, EscapeSequenceContext.Head]:
				Option.Some("\'");
				
			case [CodePointTools.DOUBLE_QUOTE, EscapeSequenceContext.Head]:
				Option.Some("\"");
				
			case [0x30, EscapeSequenceContext.Head]:
				Option.Some(String.fromCharCode(0));
				
			case [0x6E, EscapeSequenceContext.Head]:
				Option.Some("\n");
				
			case [0x72, EscapeSequenceContext.Head]:
				Option.Some("\r");
				
			case [0x74, EscapeSequenceContext.Head]:
				Option.Some("\t");
				
			case [0x75, EscapeSequenceContext.Head]:
				detail.context = EscapeSequenceContext.UnicodeHead;
				Option.None;
				
			case [CodePointTools.OPENNING_BRACE, EscapeSequenceContext.UnicodeHead]:
				detail.context = EscapeSequenceContext.UnicodeBody(0, 0);
				Option.None;
				
			case [
					0x30 | 0x31 | 0x32 | 0x33 | 0x34 | 0x35 | 0x36 | 0x37 | 0x38 | 0x39, // 0-9
					EscapeSequenceContext.UnicodeBody(count, value)
				]:
				value = (value << 4) & (code - 0x30);
				detail.context = EscapeSequenceContext.UnicodeBody(count + 1, value);
				Option.None;
				
			case [
					0x41 | 0x42 | 0x43 | 0x44 | 0x45 | 0x46, // A-F
					EscapeSequenceContext.UnicodeBody(count, value)
				]:
				value = (value << 4) & (code - 0x41 + 11);
				detail.context = EscapeSequenceContext.UnicodeBody(count + 1, value);
				Option.None;
				
			case [
					0x61 | 0x62 | 0x63 | 0x64 | 0x65 | 0x66, // a-f 
					EscapeSequenceContext.UnicodeBody(count, value)
				]:
				value = (value << 4) & (code - 0x61 + 11);
				detail.context = EscapeSequenceContext.UnicodeBody(count + 1, value);
				Option.None;
				
			case [CodePointTools.CLOSEING_BRACE, EscapeSequenceContext.UnicodeBody(count, value)]:
				if (count == 0 || 8 < count)
				{
					error(ParseErrorKind.InvalidDigitUnicodeEscape, new Range(detail.startPosition, position));
					Option.Some("");
				}
				else
				{
					try 
					{
						Option.Some(CodePoint.fromInt(value).toString());
					}
					catch (e:Exception)
					{
						error(ParseErrorKind.InvalidUnicode);
						Option.None;
					}
				}
			
			case [_, _]:
				error(ParseErrorKind.InvalidEscapeSequence, new Range(detail.startPosition, position));
				Option.None;
		}
	}
	
	// =============================
	// Start
	// =============================
	private inline function startArray():Void 
	{
		this.stack.push(output);
		output = new OutputArray();
		topContext = Context.Arr(Normal(false, true));
	}

	private inline function startUnquotedString(codePoint:CodePoint):Void
	{
		var detail = new UnquotedStringDetail(output.popTag());
		topContext = Context.UnquotedString(detail);
		
		processUnquotedString(codePoint, detail);
	}
	
	// =============================
	// End
	// =============================
	public inline function end():SoraArray
	{
		position += 1;
		
		while (true)
		{
			switch (topContext)
			{
				case Context.Arr(ArrayContext.Slash(_)):
					startUnquotedString(CodePoint.fromInt(CodePointTools.SLASH));
					
				case Context.Arr(_):
					break;
				
				case Context.QuotedString(detail):
					endQuotedString(detail);
					
				case Context.UnquotedString(detail):
					endUnquotedString(detail);
					
				case Context.OpenningQuote(singleQuoted, length):
					endOpennigQuote(singleQuoted, length);
					
				case Context.Comment(context):
					endComment(context);
			}
		}
		
		return output.end();
	}
	
	private inline function endComment(context:CommentContext) 
	{
		switch (context)
		{
			case CommentContext.Document(isInHead):
				topContext = Context.Arr(Normal(isInHead, true));
			
			case CommentContext.Normal | CommentContext.Keeping:
				topContext = Context.Arr(Normal(false, true));
		}
	}
	
	private inline function endArray(nextOutput:OutputArray):Void
	{
		var arr = new SoraArray(output.data, nextOutput.popTag());
		
		nextOutput.data.push(Sora.Arr(arr));
		topContext = Context.Arr(Normal(false, true));
	}
	
	private inline function endOpennigQuote(singleQuoted:Bool, length:Int):Void
	{
		if (length == 2)
		{
			output.data.push(
				Sora.Str(new SoraString("", output.popTag()))
			);
			topContext = Context.Arr(Normal(false, false));
		}
		else
		{
			topContext = Context.QuotedString(new QuotedStringDetail(singleQuoted, length, position - 1));
		}
	}
	
	private inline function endQuotedString(detail:QuotedStringDetail):Void
	{
		switch (detail.context)
		{
			case CarriageReturn:
				detail.newLine("\r", position);
				endUnclosedQuotedString(0, detail);
				
			case Body | Indent:
				endUnclosedQuotedString(0, detail);
				
			case Quotes(length):
				if (length < detail.quoteCount)
				{
					endUnclosedQuotedString(length, detail);
				}
				else
				{
					endClosedQuotedString(length, detail);
				}
				
			case EscapeSequence(detail):
				error(ParseErrorKind.InvalidEscapeSequence, new Range(detail.startPosition, position));
		}
	}
	
	private function endUnclosedQuotedString(quoteCount:Int, detail:QuotedStringDetail):Void
	{
		var startPosition = detail.startPosition;
		error(ParseErrorKind.UnclosedString, new Range(startPosition - detail.quoteCount, startPosition));
		topContext = Context.Arr(Normal(false, false));
	}
	
	private function endClosedQuotedString(quoteCount:Int, detail:QuotedStringDetail):Void
	{
		if (quoteCount > detail.quoteCount)
		{
			error(ParseErrorKind.TooManyClosingQuotes, new Range(position - quoteCount, position));
		}
		
		var string = "";
		var lastLine = detail.currentLine;
		var lastIndent = lastLine.indent;
		
		var iter = detail.lines.iterator();
		if (iter.hasNext())
		{
			var firstLine = iter.next();
			if (!firstLine.isWhite)
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
					error(ParseErrorKind.TooShortIndent, new Range(line.startPosition, line.startPosition + line.indent));
				}
				else if (line.content.substr(0, lastIndent) != whiteSpaces)
				{
					error(ParseErrorKind.UnmatchedIndentWhiteSpaces, new Range(line.startPosition, line.startPosition + lastIndent));
				}
				else
				{
					string += line.content.substr(lastIndent) + line.newLine;
				}
			}
		}
		else
		{
			string = lastLine.content.substr(lastIndent);
		}
		
		var soraString = new SoraString(string, output.popTag());
		output.data.push(Sora.Str(soraString));
		
		topContext = Context.Arr(Normal(false, false));
	}
	
	
	private function endUnquotedString(detail:UnquotedStringDetail):Void
	{
		switch (detail.context)
		{
			case UnquotedStringContext.Body(false):
				// do nothing.
			
			case UnquotedStringContext.Body(true):
				detail.string += "/";
				
			case UnquotedStringContext.EscapeSequence(context):
				error(ParseErrorKind.InvalidEscapeSequence);
		}
		
		var soraString = new SoraString(detail.string, detail.tag);
		output.data.push(Sora.Str(soraString));
		
		topContext = Context.Arr(Normal(false, false));
	}
	
	// =============================
	// Error
	// =============================
	private inline function error(kind:ParseErrorKind, ?range:Range):Void 
	{
		if (range == null)
		{
			range = new Range(this.position - 1, this.position);
		}
		
		var entry = new ParseErrorEntry(kind, range);
		errors.push(entry);
		
		if (!config.persevering)
		{
			throw new ParseError(Option.None, errors);
		}
	}
}


private enum Context 
{
	Arr(context:ArrayContext);
	OpenningQuote(singleQuoted:Bool, length:Int);
	QuotedString(detail:QuotedStringDetail);
	UnquotedString(detail:UnquotedStringDetail);
	Comment(detail:CommentContext);
}

private enum ArrayContext 
{
	Normal(isInHead:Bool, separated:Bool);
	Slash(isInHead:Bool, length:Int);
}

private class QuotedStringDetail 
{
	public var currentLine:QuotedStringLine;
	public var lines:Array<QuotedStringLine>;
	
	public var context:QuotedStringContext;
	public var singleQuoted:Bool;
	public var quoteCount:Int;
	public var startPosition:Int;
	
	public inline function new(singleQuoted:Bool, quoteCount:Int, startPosition:Int) 
	{
		this.singleQuoted = singleQuoted;
		this.quoteCount = quoteCount;
		this.startPosition = startPosition;
		this.lines = [];
		this.currentLine = new QuotedStringLine(startPosition);
		this.context = QuotedStringContext.Indent;
	}
	
	public inline function newLine(string:String, position:Int):Void 
	{
		currentLine.newLine = string;
		currentLine.isWhite = context.equals(QuotedStringContext.Indent);
		lines.push(currentLine);
		currentLine = new QuotedStringLine(position);
		context = QuotedStringContext.Indent;
	}
	
	public inline function matchQuote(codePoint:CodePoint):Bool
	{
		return switch [codePoint.toInt(), singleQuoted]
		{
			case [CodePointTools.SINGLE_QUOTE, true] | [CodePointTools.DOUBLE_QUOTE, false]:
				true;
				
			case _:
				false;
		}
	}
	
	public inline function addQuotes(length:Int):Void
	{
		var char = if (singleQuoted) CodePointTools.SINGLE_QUOTE else CodePointTools.DOUBLE_QUOTE;
		var string = String.fromCharCode(char);
		for (i in 0...length)
		{
			currentLine.content += string;
		}
	}
}

private class QuotedStringLine 
{
	public var startPosition:Int;
	public var content:String;
	public var indent:Int;
	public var newLine:String;
	public var isWhite:Bool;
	
	public inline function new(startPosition:Int) 
	{
		this.startPosition = startPosition;
		
		content = "";
		indent = 0;
	}
}

private enum QuotedStringContext
{
	Indent;
	Body;
	CarriageReturn;
	Quotes(length:Int);
	EscapeSequence(detail:EscapeSequenceDetail);
}

private class EscapeSequenceDetail
{
	public var context:EscapeSequenceContext;
	public var startPosition:Int;
	
	public inline function new(startPosition:Int)
	{
		this.startPosition = startPosition;
		context = EscapeSequenceContext.Head;
	}
}

private enum EscapeSequenceContext 
{
	Head;
	UnicodeHead;
	UnicodeBody(count:Int, value:Int);
}

private class UnquotedStringDetail
{
	public var string:String;
	public var context:UnquotedStringContext;
	public var tag:Tag;
	
	public inline function new(tag:Tag) 
	{
		string = "";
		context = UnquotedStringContext.Body(false);
		this.tag = tag;
	}
}

private enum UnquotedStringContext
{
	Body(isSlash:Bool);
	EscapeSequence(detail:EscapeSequenceDetail);
}

private enum CommentContext 
{
	Normal;
	Keeping;
	Document(isInHead:Bool);
}

private class OutputArray 
{
	public var data:Array<Sora>;
	public var footTag:Tag;
	private var tag:Tag;
	
	public function new () 
	{
		data = [];
		footTag = new Tag();
	}
	
	public function popTag():Tag
	{
		var oldTag = this.footTag;
		this.footTag = new Tag();
		return oldTag;
	}
	
	public function end():SoraArray
	{
		return new SoraArray(data, tag);
	}
}

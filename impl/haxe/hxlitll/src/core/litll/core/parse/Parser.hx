package litll.core.parse;

import haxe.ds.Option;
import litll.core.LitllArray;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.core.ds.SourceMap;
import litll.core.ds.SourceRange;
import litll.core.parse.tag.UnsettledArrayTag;
import litll.core.parse.tag.UnsettledLeadingTag;
import litll.core.parse.tag.UnsettledStringTag;
import litll.core.parse.tag.UnsettledStringTag;
import litll.core.tag.ArrayTag;
import unifill.CodePoint;
import unifill.Exception;

using unifill.Unifill;
using litll.core.char.NewLineCharTools;
using litll.core.char.CodePointTools;

class Parser
{
	private var config:ParserConfig;
	private var position:Int;
	private var output:OutputArray;
	private var stack:Array<OutputArray>;
	private var errors:Array<ParseErrorEntry>;
	private var topContext:Context;
	private var string:String;
	private var sourceMap:SourceMap;
	private var cr:Bool;
	
	public inline function new(string:String, config:ParserConfig) 
	{
		this.string = string;
		this.config = config;
		cr = false;
		position = 0;
		errors = [];
		sourceMap = new SourceMap(0, 0, 0, 1);
		var tag = new UnsettledLeadingTag(sourceMap).toArrayTag(0);
		output = new OutputArray(tag);
		stack = [];
		topContext = Context.Arr(ArrayContext.Normal(true, true));
	}
	
	public static function run(string:String, ?config:ParserConfig):Result<LitllArray<Litll>, ParseError> 
	{
		if (config == null) 
		{
			config = new ParserConfig();
		}
		
		var parser = new Parser(string, config);
		try
		{
			for (codePoint in string.uIterator())
			{
				parser.process(codePoint);
			}
			
			return parser.end();
		}
		catch (error:ParseError)
		{
			return Result.Err(error);
		}
	}
	
	
	// =============================
	// Process
	// =============================
	public inline function process(codePoint:CodePoint):Void
	{
		position++;
		var c = codePoint.toInt();
		if (c == CodePointTools.CR)
		{
			cr = true;
		}
		else if (c == CodePointTools.LF)
		{
			cr = false;
			sourceMap.addLine(position, position, sourceMap.lineNumber, 0);
		}
		else
		{
			if (cr)
			{
				sourceMap.addLine(position - 1, position - 1, sourceMap.lineNumber, 0);
			}
			cr = false;
		}
		
		this.processCurrent(codePoint);
	}
	
	private inline function processCurrent(codePoint:CodePoint):Void
	{
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
				topContext = Context.Comment(new CommentDetail(CommentKind.Document(isInHead)));
			
			case [CodePointTools.SLASH, ArrayContext.Slash(isInHead, length)]:
				topContext = Context.Arr(ArrayContext.Slash(isInHead, length + 1));
				
			case [_, ArrayContext.Slash(isInHead, 2)]:
				var commentDetail = new CommentDetail(CommentKind.Normal);
				topContext = Context.Comment(commentDetail);
				processComment(codePoint, commentDetail);
				
			case [_, ArrayContext.Slash(isInHead, 1)]:
				startUnquotedString(CodePoint.fromInt(CodePointTools.SLASH));
				processCurrent(codePoint);
				
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
					error(ParseErrorKind.TooManyClosingBracket);
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
				topContext = Context.OpenningQuote(false, 1);
				
			case [CodePointTools.SINGLE_QUOTE, ArrayContext.Normal(_, separated)]:
				if (!separated)
				{
					error(ParseErrorKind.SeparatorRequired);
				}
				topContext = Context.OpenningQuote(true, 1);
				
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
					if (!separated)
					{
						error(ParseErrorKind.SeparatorRequired);
					}
					startUnquotedString(codePoint);
				}
		}
	}
	
	private inline function processComment(codePoint:CodePoint, detail:CommentDetail):Void
	{
		switch [codePoint.toInt(), detail.context]
		{
			case [CodePointTools.EXCLAMATION, CommentContext.Head]:
				detail.keeping = true;
				detail.context = CommentContext.Body;
			
			case [_, CommentContext.Head]:
				detail.context = CommentContext.Body;
				processComment(codePoint, detail);
				
			case [CodePointTools.LF, CommentContext.CarriageReturn | CommentContext.Body]:
				writeComment(codePoint, detail);
				endComment(detail);
			
			case [_, CommentContext.CarriageReturn]:
				endComment(detail);
				processCurrent(codePoint);
			
			case [CodePointTools.CR, CommentContext.Body]:
				writeComment(codePoint, detail);
				detail.context = CommentContext.CarriageReturn;
			
			case [_, CommentContext.Body]:
				writeComment(codePoint, detail);
		}
	}
	
	public function writeComment(codePoint:CodePoint, detail:CommentDetail):Void
	{
		switch (detail.kind)
		{
			case CommentKind.Normal:
				// TODO: format tag
				
			case CommentKind.Document(isInHead):
				var tag = if (isInHead) output.tag.leadingTag else output.elementTag;
				tag.writeDocument(config, codePoint, position - 1);
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
				processCurrent(codePoint);
		}
	}
	
	private function processQuotedString(codePoint:CodePoint, detail:QuotedStringDetail):Void
	{
		switch (detail.context) 
		{
			case QuotedStringContext.EscapeSequence(escapeSequence):
				processEscapeSequence(codePoint, escapeSequence).iter(
					function (string)
					{
						detail.currentLine.content += string;
						detail.context = QuotedStringContext.Body;
					}
				);
			
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
						processCurrent(codePoint);
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
	
	private function processUnquotedString(codePoint:CodePoint, detail:UnquotedStringDetail):Void
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
				processEscapeSequence(codePoint, context).iter(
					function (unescapedCodePoint):Void
					{
						detail.string += unescapedCodePoint.toString();
						detail.context = UnquotedStringContext.Body(false);
					}
				);
				
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
				processCurrent(codePoint);
			
			// --------------------------
			// Other, Normal
			// --------------------------
			case [_, UnquotedStringContext.Body(false)]:
				if (CodePointTools.isBlackListedWhitespace(codePoint))
				{
					endUnquotedString(detail);
					processCurrent(codePoint);
				}
				else
				{
					detail.string += codePoint.toString();
				}
		}
	}

	private function processEscapeSequence(codePoint:CodePoint, detail:EscapeSequenceDetail):Maybe<String>
	{
		var code = codePoint.toInt();
		
		return switch [code, detail.context]
		{
			case [CodePointTools.BACK_SLASH, EscapeSequenceContext.Head]:
				Maybe.some("\\");
			
			case [CodePointTools.SINGLE_QUOTE, EscapeSequenceContext.Head]:
				Maybe.some("\'");
				
			case [CodePointTools.DOUBLE_QUOTE, EscapeSequenceContext.Head]:
				Maybe.some("\"");
				
			case [0x30, EscapeSequenceContext.Head]:
				Maybe.some(String.fromCharCode(0));
				
			case [0x6E, EscapeSequenceContext.Head]:
				Maybe.some("\n");
				
			case [0x72, EscapeSequenceContext.Head]:
				Maybe.some("\r");
				
			case [0x74, EscapeSequenceContext.Head]:
				Maybe.some("\t");
				
			case [0x75, EscapeSequenceContext.Head]:
				detail.context = EscapeSequenceContext.UnicodeHead;
				Maybe.none();
				
			case [CodePointTools.OPENNING_BRACE, EscapeSequenceContext.UnicodeHead]:
				detail.context = EscapeSequenceContext.UnicodeBody(0, 0);
				Maybe.none();
				
			case [
					0x30 | 0x31 | 0x32 | 0x33 | 0x34 | 0x35 | 0x36 | 0x37 | 0x38 | 0x39, // 0-9
					EscapeSequenceContext.UnicodeBody(count, value)
				]:
				value = (value << 4) | (code - 0x30);
				detail.context = EscapeSequenceContext.UnicodeBody(count + 1, value);
				Maybe.none();
				
			case [
					0x41 | 0x42 | 0x43 | 0x44 | 0x45 | 0x46, // A-F
					EscapeSequenceContext.UnicodeBody(count, value)
				]:
				value = (value << 4) | (code - 0x41 + 10);
				detail.context = EscapeSequenceContext.UnicodeBody(count + 1, value);
				Maybe.none();
				
			case [
					0x61 | 0x62 | 0x63 | 0x64 | 0x65 | 0x66, // a-f 
					EscapeSequenceContext.UnicodeBody(count, value)
				]:
				value = (value << 4) | (code - 0x61 + 10);
				detail.context = EscapeSequenceContext.UnicodeBody(count + 1, value);
				Maybe.none();
				
			case [CodePointTools.CLOSEING_BRACE, EscapeSequenceContext.UnicodeBody(count, value)]:
				if (count == 0 || 6 < count)
				{
					error(ParseErrorKind.InvalidDigitUnicodeEscape, new SourceRange(sourceMap, detail.startPosition, position));
					Maybe.some("");
				}
				else
				{
					try 
					{
						Maybe.some(CodePoint.fromInt(value).toString());
					}
					catch (e:Exception)
					{
						error(ParseErrorKind.InvalidUnicode);
						Maybe.none();
					}
				}
			
			case [_, _]:
				error(ParseErrorKind.InvalidEscapeSequence, new SourceRange(sourceMap, detail.startPosition, position));
				Maybe.none();
		}
	}
	
	// =============================
	// Start
	// =============================
	private inline function startArray():Void 
	{
		this.stack.push(output);
		output = new OutputArray(output.popArrayTag(position - 1));
		topContext = Context.Arr(Normal(false, true));
	}

	private inline function startUnquotedString(codePoint:CodePoint):Void
	{
		var detail = new UnquotedStringDetail(output.popStringTag(position));
		topContext = Context.UnquotedString(detail);
		
		processUnquotedString(codePoint, detail);
	}
	
	// =============================
	// End
	// =============================
	public inline function end():Result<LitllArray<Litll>, ParseError> 
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
		
		while (stack.length > 0)
		{
			var nextOutput = stack.pop();
			error(ParseErrorKind.UnclosedArray, new SourceRange(sourceMap, nextOutput.tag.startPosition, nextOutput.tag.startPosition + 1));
			endArray(nextOutput);
		}
		
		var data = output.end(position);
		return if (errors.length > 0)
		{
			Result.Err(new ParseError(Maybe.some(data), errors));
		}
		else
		{
			Result.Ok(data);
		}
	}
	
	private inline function endComment(detail:CommentDetail) 
	{
		switch (detail.kind)
		{
			case CommentKind.Document(isInHead):
				topContext = Context.Arr(Normal(isInHead, true));
			
			case CommentKind.Normal:
				topContext = Context.Arr(Normal(false, true));
		}
	}
	
	private inline function endArray(nextOutput:OutputArray):Void
	{
		var arr = new LitllArray<Litll>(output.data, nextOutput.tag.settle(position));
		
		nextOutput.data.push(Litll.Arr(arr));
		output = nextOutput;
		
		topContext = Context.Arr(Normal(false, true));
	}
	
	private inline function endOpennigQuote(singleQuoted:Bool, length:Int):Void
	{
		if (length == 2)
		{
			output.data.push(Litll.Str(new LitllString("", output.popStringTag(position - 2).settle(position))));
			topContext = Context.Arr(Normal(false, false));
		}
		else
		{
			topContext = Context.QuotedString(new QuotedStringDetail(singleQuoted, length, output.popStringTag(position - length)));
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
				error(ParseErrorKind.InvalidEscapeSequence, new SourceRange(sourceMap, detail.startPosition, position));
		}
	}
	
	private function endUnclosedQuotedString(quoteCount:Int, detail:QuotedStringDetail):Void
	{
		var startPosition = detail.tag.startPosition;
		error(ParseErrorKind.UnclosedQuote, new SourceRange(sourceMap, startPosition - detail.quoteCount, startPosition));
		topContext = Context.Arr(Normal(false, false));
	}
	
	private function endClosedQuotedString(quoteCount:Int, detail:QuotedStringDetail):Void
	{
		if (quoteCount > detail.quoteCount)
		{
			error(ParseErrorKind.TooManyClosingQuotes(detail.quoteCount, quoteCount), new SourceRange(sourceMap, position - quoteCount, position));
		}
		
		var string = "";
		var lastLine = detail.currentLine;
		var lastIndent = lastLine.indent;
		
		var iter = detail.lines.iterator();
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
					error(ParseErrorKind.TooShortIndent, new SourceRange(sourceMap, line.startPosition, line.startPosition + line.indent));
				}
				else if (line.content.substr(0, lastIndent) != whiteSpaces)
				{
					error(ParseErrorKind.UnmatchedIndentWhiteSpaces, new SourceRange(sourceMap, line.startPosition, line.startPosition + lastIndent));
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
		
		var litllString = new LitllString(string, detail.tag.settle(position));
		output.data.push(Litll.Str(litllString));
		
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
		
		var litllString = new LitllString(detail.string, detail.tag.settle(position));
		output.data.push(Litll.Str(litllString));
		
		topContext = Context.Arr(Normal(false, false));
	}
	
	// =============================
	// Error
	// =============================
	private inline function error(kind:ParseErrorKind, ?range:SourceRange):Void 
	{
		if (range == null)
		{
			range = new SourceRange(sourceMap, this.position - 1, this.position);
		}
		
		var entry = new ParseErrorEntry(string, kind, range);
		errors.push(entry);
		
		if (!config.persevering)
		{
			throw new ParseError(Maybe.none(), errors);
		}
	}
}


private enum Context 
{
	Arr(context:ArrayContext);
	OpenningQuote(singleQuoted:Bool, length:Int);
	QuotedString(detail:QuotedStringDetail);
	UnquotedString(detail:UnquotedStringDetail);
	Comment(detail:CommentDetail);
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
	public var tag:UnsettledStringTag;
	
	public function new(singleQuoted:Bool, quoteCount:Int, tag:UnsettledStringTag) 
	{
		this.singleQuoted = singleQuoted;
		this.quoteCount = quoteCount;
		this.tag = tag;
		this.lines = [];
		this.currentLine = new QuotedStringLine(tag.startPosition);
		this.context = QuotedStringContext.Indent;
	}
	
	public inline function newLine(string:String, position:Int):Void 
	{
		currentLine.newLine = string;
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
	
	public function isWhite():Bool
	{
		return content.length == indent;
	}
	
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
	public var tag:UnsettledStringTag;
	
	public inline function new(tag:UnsettledStringTag) 
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

private class CommentDetail
{
	public var keeping:Bool;
	public var context:CommentContext;
	public var kind(default, null):CommentKind;
	
	public inline function new (kind:CommentKind)
	{
		this.kind = kind;
		this.keeping = false;
		this.context = CommentContext.Head;
	}
}

private enum CommentKind
{
	Normal;
	Document(isInHead:Bool);
}

private enum CommentContext
{
	Head;
	Body;
	CarriageReturn;
}

private class OutputArray 
{
	public var data(default, null):Array<Litll>;
	public var tag(default, null):UnsettledArrayTag;
	public var elementTag(default, null):UnsettledLeadingTag;
	
	public function new (tag:UnsettledArrayTag) 
	{
		this.tag = tag;
		data = [];
		this.elementTag = new UnsettledLeadingTag(tag.leadingTag.sourceMap);
	}
	
	private inline function popTag():UnsettledLeadingTag
	{
		var oldTag = this.elementTag;
		this.elementTag = new UnsettledLeadingTag(tag.leadingTag.sourceMap);
		return oldTag;
	}
	
	public function popStringTag(position:Int) 
	{
		return popTag().toStringTag(position);
	}
	
	public function popArrayTag(position:Int) 
	{
		return popTag().toArrayTag(position);
	}
	
	public inline function end(position:Int):LitllArray<Litll>
	{
		return new LitllArray<Litll>(data, tag.settle(position));
	}
	
}

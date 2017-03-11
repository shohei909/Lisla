package litll.core.parse;
import hxext.ds.Maybe;
import litll.core.ds.SourceRange;
import litll.core.error.InlineErrorSummary;

class ParseErrorEntry
{
	public var source(default, null):String;
	public var kind(default, null):ParseErrorKind;
	public var range(default, null):SourceRange;
	
	public var message(get, never):String;
	public function get_message():String
	{
		return switch (kind)
		{
			case ParseErrorKind.BlacklistedWhitespace(codePoint):
				"Char 0x" + StringTools.hex(codePoint.toInt()) + " is blacklisted whitespace. It can't be use without quoting.";
				
			case ParseErrorKind.UnquotedEscapeSequence:
				"Escape sequence is not supported for unquoted sequence.";
				
			case ParseErrorKind.InvalidInterpolationSeparator:
				"Interpolation separator is used in not interpolation context.";
				
			case ParseErrorKind.InvalidEscapeSequence:
				"Invalid escape sequence.";
				
			case ParseErrorKind.InvalidDigitUnicodeEscape:
				"Digit of unicode must be 1-6.";
				
			case ParseErrorKind.InvalidUnicode:
				"Invalid unicode.";
				
			case ParseErrorKind.UnclosedArray:
				"Unclosed array.";
				
			case ParseErrorKind.UnclosedQuote:
				"Unclosed quote.";
				
			case ParseErrorKind.TooManyClosingQuotes(expected, actual):
				"Too many closing quotes. " + expected + " expected but actual " + actual;
				
			case ParseErrorKind.TooManyClosingBracket:
				"Too many closing brackets.";
				
			case ParseErrorKind.TooShortIndent:
				"Too short indent.";
				
			case ParseErrorKind.UnmatchedIndentWhiteSpaces:
				"Indent white spaces are unmatched.";
		}
	}
	
	public inline function new(source:String, kind:ParseErrorKind, range:SourceRange) 
	{
		this.source = source;
		this.kind = kind;
		this.range = range;
	}
	
    public function getSummary():InlineErrorSummary<ParseErrorKind>
    {
        return new InlineErrorSummary(
            Maybe.some(range),
            message,
            kind
        );
    }
}

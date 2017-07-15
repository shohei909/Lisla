package lisla.error.parse;
import lisla.error.core.ErrorName;
import lisla.error.core.LislaError;
import unifill.CodePoint;

class BasicParseError implements LislaError
{
    public var kind(default, null):BasicParseErrorKind;
    
    public inline function new (kind:BasicParseErrorKind)
    {
        this.kind = kind;
    }
    
    public function toString():String 
    {
        return switch (kind)
        {
			case BasicParseErrorKind.BlacklistedWhitespace(codePoint):
				"Char 0x" + StringTools.hex(codePoint.toInt()) + " is blacklisted whitespace. It can't be use without quoting.";
				
			case BasicParseErrorKind.UnquotedEscapeSequence:
				"Escape sequence is not supported for unquoted sequence.";
				
			case BasicParseErrorKind.InvalidInterpolationSeparator:
				"Interpolation separator is used in not interpolation context.";
				
			case BasicParseErrorKind.InvalidEscapeSequence:
				"Invalid escape sequence.";
				
			case BasicParseErrorKind.InvalidDigitUnicodeEscape:
				"Digit of unicode must be 1-6.";
				
			case BasicParseErrorKind.InvalidUnicode:
				"Invalid unicode.";
				
			case BasicParseErrorKind.UnclosedArray:
				"Unclosed array.";
				
			case BasicParseErrorKind.UnclosedQuote:
				"Unclosed quote.";
				
			case BasicParseErrorKind.TooManyClosingQuotes(expected, actual):
				"Too many closing quotes. " + expected + " expected but actual " + actual;
				
			case BasicParseErrorKind.TooManyClosingBracket:
				"Too many closing brackets.";
				
			case BasicParseErrorKind.TooShortIndent:
				"Too short indent.";
				
			case BasicParseErrorKind.UnmatchedIndentWhiteSpaces:
				"Indent white spaces are unmatched.";
        }
    }
    
    public function getErrorName():ErrorName 
    {
        return ErrorName.fromEnum(kind);
    }
}

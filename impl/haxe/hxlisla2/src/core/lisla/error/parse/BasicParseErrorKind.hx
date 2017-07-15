package lisla.error.parse;
import unifill.CodePoint;

enum BasicParseErrorKind 
{
    BlacklistedWhitespace(chararacter:CodePoint);
    InvalidEscapeSequence;
    InvalidDigitUnicodeEscape;
    InvalidUnicode;
    InvalidInterpolationSeparator;
    UnquotedEscapeSequence;
    UnclosedArray;
    UnclosedQuote;
    TooManyClosingQuotes(expected:Int, actual:Int);
	TooManyClosingBracket;
	TooShortIndent;
	UnmatchedIndentWhiteSpaces;
}
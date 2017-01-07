package litll.core.parse;
import unifill.CodePoint;

enum ParseErrorKind
{
    BlacklistedWhitespace(chararacter:CodePoint);
    InvalidEscapeSequence;
    InvalidDigitUnicodeEscape;
    InvalidUnicode;
    UnclosedArray;
    UnclosedQuote;
    TooManyClosingQuotes(expected:Int, actual:Int);
	TooManyClosingBracket;
    SeparatorRequired;
	TooShortIndent;
	UnmatchedIndentWhiteSpaces;
}

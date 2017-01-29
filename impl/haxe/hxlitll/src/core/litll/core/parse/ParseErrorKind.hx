package litll.core.parse;
import unifill.CodePoint;

enum ParseErrorKind
{
    BlacklistedWhitespace(chararacter:CodePoint);
    InvalidEscapeSequence;
    InvalidDigitUnicodeEscape;
    InvalidUnicode;
    UnquotedEscapeSequence;
    UnclosedArray;
    UnclosedQuote;
    TooManyClosingQuotes(expected:Int, actual:Int);
	TooManyClosingBracket;
	TooShortIndent;
	UnmatchedIndentWhiteSpaces;
}

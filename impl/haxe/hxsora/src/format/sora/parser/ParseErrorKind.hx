package format.sora.parser;
import unifill.CodePoint;

enum ParseErrorKind
{
    BlacklistedWhitespace(chararacter:CodePoint);
    InvalidEscapeSequence;
    InvalidDigitUnicodeEscape;
    InvalidUnicode;
    UnclosedArray;
    UnclosedString;
    ExtraClosingBracket;
    TooManyClosingQuotes(expected:Int, actural:Int);
	TooManyClosingBracket;
    SeparatorRequired;
	TooShortIndent;
	UnmatchedIndentWhiteSpaces;
}

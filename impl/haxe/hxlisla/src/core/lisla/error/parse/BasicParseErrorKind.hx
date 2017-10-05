package lisla.error.parse;
import unifill.CodePoint;

enum BasicParseErrorKind 
{
    BlacklistedWhitespace(chararacter:CodePoint);
    SeparaterRequired;
    UnclosedArray;
    UnclosedQuote;
    TooManyClosingQuotes(expected:Int, actual:Int);
	TooManyClosingBracket;
	UnmatchedIndentWhiteSpaces;
    InvalidPlaceholderPosition;
    EmptyPlaceholder;
}
package lisla.error.parse;
import unifill.CodePoint;

enum BasicParseErrorKind 
{
    BlacklistedWhitespace(chararacter:CodePoint);
    SeparaterRequired;
    UnclosedArray;
    UnclosedQuote;
	TooManyClosingBracket;
	UnmatchedIndentWhiteSpaces;
    InvalidPlaceholderPosition;
    EmptyPlaceholder;
}
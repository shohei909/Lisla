package lisla.error.parse;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.error.core.ElementaryError;
import lisla.error.core.ErrorName;
import lisla.error.core.InlineError;

class BasicParseError
    implements InlineError 
    implements ElementaryError
{
    public var kind(default, null):BasicParseErrorKind;
    public var range(default, null):Range;
    
    public inline function new (kind:BasicParseErrorKind, range:Range)
    {
        this.kind = kind;
        this.range = range;
    }
    
    public function getMessage():String 
    {
        return switch (kind)
        {
			case BasicParseErrorKind.BlacklistedWhitespace(codePoint):
				"Char 0x" + StringTools.hex(codePoint.toInt()) + " is blacklisted whitespace. It can't be use without quoting.";
				
			case BasicParseErrorKind.SeparaterRequired:
				"Separater required.";
                
			case BasicParseErrorKind.UnclosedArray:
				"Unclosed array.";
				
			case BasicParseErrorKind.UnclosedQuote:
				"Unclosed quote.";
				
			case BasicParseErrorKind.EmptyPlaceholder:
				"Empty placeholder.";
				
			case BasicParseErrorKind.InvalidPlaceholderPosition:
				"Invalid placeholder position.";
				
			case BasicParseErrorKind.TooManyClosingQuotes(expected, actual):
				"Too many closing quotes. " + expected + " expected but actual " + actual;
				
			case BasicParseErrorKind.TooManyClosingBracket:
				"Too many closing brackets.";
				
			case BasicParseErrorKind.UnmatchedIndentWhiteSpaces:
				"Indent white spaces are unmatched.";
        }
    }
    
    public function getErrorName():ErrorName 
    {
        return ErrorName.fromEnum(kind);
    }
    
    public function getOptionRange():Option<Range>
    {
        return Option.Some(range); 
    }
    
    public function getInlineError():InlineError
    {
        return this;
    }
    
    public function getElementaryError():ElementaryError 
    {
        return this;
    }
}

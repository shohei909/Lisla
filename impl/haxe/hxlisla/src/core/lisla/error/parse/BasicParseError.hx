package lisla.error.parse;
import haxe.ds.Option;
import lisla.data.meta.position.Position;
import lisla.data.meta.position.Range;
import lisla.error.core.Error;
import lisla.error.core.ErrorName;
import lisla.error.core.IErrorDetail;

class BasicParseError extends Error<BasicParseErrorDetail>
{
    public function new(kind:BasicParseErrorKind, position:Position)
    {
        super(
            new BasicParseErrorDetail(kind),
            position
        );
    }
}

class BasicParseErrorDetail implements IErrorDetail
{
    public var kind(default, null):BasicParseErrorKind;
    
    public inline function new (kind:BasicParseErrorKind)
    {
        this.kind = kind;
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
    
    public function getDetail():IErrorDetail
    {
        return this;
    }
}

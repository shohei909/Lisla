package lisla.parse.array;
import lisla.parse.string.QuotedStringContext;
import lisla.parse.string.UnquotedStringContext;
import lisla.parse.metadata.UnsettledArrayTag;
import lisla.parse.metadata.UnsettledLeadingTag;

enum ArrayState
{
	Normal;
    Escape;
	Semicolon;
    Comment(context:CommentContext);
	OpeningQuote(singleQuoted:Bool, length:Int);
	QuotedString(context:QuotedStringContext);
	UnquotedString(context:UnquotedStringContext);
}

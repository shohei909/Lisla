package lisla.core.parse.array;
import lisla.core.parse.string.QuotedStringContext;
import lisla.core.parse.string.UnquotedStringContext;
import lisla.core.parse.tag.UnsettledArrayTag;
import lisla.core.parse.tag.UnsettledLeadingTag;

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

package litll.core.parse.array;
import litll.core.parse.string.QuotedStringContext;
import litll.core.parse.string.UnquotedStringContext;
import litll.core.parse.tag.UnsettledArrayTag;
import litll.core.parse.tag.UnsettledLeadingTag;

enum ArrayState
{
	Normal;
    Escape;
	Slash(length:Int);
    Comment(context:CommentContext);
	OpeningQuote(singleQuoted:Bool, length:Int);
	QuotedString(context:QuotedStringContext);
	UnquotedString(context:UnquotedStringContext);
}

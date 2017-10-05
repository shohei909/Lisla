package lisla.parse.array;
import lisla.parse.string.QuotedStringContext;
import lisla.parse.string.UnquotedStringContext;
import lisla.parse.tag.UnsettledArrayTag;
import lisla.parse.tag.UnsettledLeadingTag;

enum ArrayState
{
	Normal(separated:Bool);
	Dollar;
	Semicolon;
    Comment(context:CommentContext);
	OpeningQuote(singleQuoted:Bool, placeholder:Bool, length:Int);
	QuotedString(context:QuotedStringContext);
	UnquotedString(context:UnquotedStringContext);
}

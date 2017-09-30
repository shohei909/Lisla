package lisla.parse.array;
import lisla.parse.string.QuotedStringContext;
import lisla.parse.string.UnquotedStringContext;
import lisla.parse.metadata.UnsettledArrayTag;
import lisla.parse.metadata.UnsettledLeadingTag;

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

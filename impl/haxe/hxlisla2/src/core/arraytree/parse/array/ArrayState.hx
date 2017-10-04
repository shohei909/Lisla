package arraytree.parse.array;
import arraytree.parse.string.QuotedStringContext;
import arraytree.parse.string.UnquotedStringContext;
import arraytree.parse.tag.UnsettledArrayTag;
import arraytree.parse.tag.UnsettledLeadingTag;

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

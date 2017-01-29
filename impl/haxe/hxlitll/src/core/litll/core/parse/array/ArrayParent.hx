package litll.core.parse.array;
import litll.core.parse.string.QuotedStringContext;
import litll.core.parse.string.QuotedStringArrayPair;

enum ArrayParent
{
    Top;
    Array(context:ArrayContext);
    QuotedString(stringContext:QuotedStringContext, store:QuotedStringArrayPair);
}

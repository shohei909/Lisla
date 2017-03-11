package lisla.core.parse.array;
import lisla.core.parse.string.QuotedStringContext;
import lisla.core.parse.string.QuotedStringArrayPair;

enum ArrayParent
{
    Top;
    Array(context:ArrayContext);
    QuotedString(stringContext:QuotedStringContext, store:QuotedStringArrayPair);
}

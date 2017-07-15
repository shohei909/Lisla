package lisla.parse.array;
import lisla.parse.string.QuotedStringContext;
import lisla.parse.string.QuotedStringArrayPair;

enum ArrayParent
{
    Top;
    Array(context:ArrayContext);
    QuotedString(stringContext:QuotedStringContext, store:QuotedStringArrayPair);
}

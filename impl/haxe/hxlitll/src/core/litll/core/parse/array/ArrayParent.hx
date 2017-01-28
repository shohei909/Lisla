package litll.core.parse.array;
import litll.core.parse.string.QuotedStringContext;

enum ArrayParent
{
    Top;
    Array(context:ArrayContext);
    QuotedString(arrayContext:ArrayContext, stringContext:QuotedStringContext, storedArray:Array<LitllArray<Litll>>);
}

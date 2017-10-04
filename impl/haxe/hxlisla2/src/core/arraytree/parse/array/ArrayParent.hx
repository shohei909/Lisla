package arraytree.parse.array;
import arraytree.parse.string.QuotedStringContext;
import arraytree.parse.string.QuotedStringArrayPair;

enum ArrayParent
{
    Top;
    Array(context:ArrayContext);
}

package litll.core.parse.string;
import litll.core.tag.StringTag;

class QuotedStringArrayPair
{
    public var string:Array<QuotedStringLine>;
    public var array:Array<LitllArray<Litll>>;
    public var tag:StringTag;

    public function new(string:Array<QuotedStringLine>, tag:StringTag)
    {
        this.string = string;
        this.array = [];
    }
}

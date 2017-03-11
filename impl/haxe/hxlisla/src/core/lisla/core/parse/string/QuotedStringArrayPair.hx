package lisla.core.parse.string;
import lisla.core.tag.StringTag;

class QuotedStringArrayPair
{
    public var string:Array<QuotedStringLine>;
    public var array:Array<LislaArray<Lisla>>;
    public var tag:StringTag;

    public function new(string:Array<QuotedStringLine>, tag:StringTag)
    {
        this.string = string;
        this.array = [];
    }
}

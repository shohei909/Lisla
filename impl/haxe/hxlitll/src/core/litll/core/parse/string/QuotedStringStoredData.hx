package litll.core.parse.string;

class QuotedStringStoredData
{
    public var string:Array<QuotedStringLine>;
    public var array:Array<LitllArray<Litll>>;
    
    public function new(string:Array<QuotedStringLine>, array:Array<LitllArray<Litll>>)
    {
        this.string = string;
        this.array = array;
    }
}

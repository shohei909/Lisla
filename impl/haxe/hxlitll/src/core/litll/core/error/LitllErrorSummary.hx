package litll.core.error;
import haxe.ds.Option;
import hxext.ds.Maybe;
import litll.core.LitllArray;
import litll.core.LitllString;
import litll.core.ds.SourceRange;
import litll.core.tag.Tag;

class LitllErrorSummary implements ErrorSummary
{
    public var range:Maybe<SourceRange>;
    public var message:String;
    
    public function new(range:Maybe<SourceRange>, message:String) 
    {
        this.range = range;
        this.message = message;
    }
    
    public static function createWithTag(tag:Maybe<Tag>, message:String) 
    {
        var range = tag.flatMap(function (t) return t.position);
        return new LitllErrorSummary(range, message);
    }
    
    public function toString():String
    {
        return range.map(function (r) return r.toString() + ": ").getOrElse("") + message;
    }
    
    public function toLitll():Litll
    {
        return Litll.Arr(
            new LitllArray(
                [
                    Litll.Arr(
                        switch (range.toOption())
                        {
                            case Option.Some(range):
                                range.toLitllArray();
                                
                            case Option.None:
                                new LitllArray([]);
                        }
                    ),
                    Litll.Str(new LitllString(message))
                ]
            )
        );
    }
}

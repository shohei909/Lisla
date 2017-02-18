package litll.core.error;
import hxext.ds.Maybe;
import litll.core.ds.SourceRange;
import litll.core.tag.Tag;

class LitllErrorSummary
{
    public var range:Maybe<SourceRange>;
    public var message:String;
    
    public function new(range:Maybe<SourceRange>, message:String) 
    {
        this.range = range;
        this.message = message;
    }
    
    public function toString():String
    {
        return range.map(function (r) return r.toString() + ": ").getOrElse("") + message;
    }
    
    public static function createWithTag(tag:Maybe<Tag>, message:String) 
    {
        var range = tag.flatMap(function (t) return t.position);
        return new LitllErrorSummary(range, message);
    }
}

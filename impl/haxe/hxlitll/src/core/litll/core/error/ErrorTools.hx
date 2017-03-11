package litll.core.error;
import hxext.ds.Maybe;
import litll.core.tag.Tag;

class ErrorTools 
{
    public static function messageWithTag(tag:Maybe<Tag>, message:String):String
    {
        var range = tag.flatMap(function (t) return t.range);
        return range.map(function (r) return r.toString() + ": ").getOrElse("") + message;
    }
}

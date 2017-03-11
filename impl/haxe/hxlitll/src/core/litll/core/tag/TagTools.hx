package lisla.core.tag;
import hxext.ds.Maybe;
import lisla.core.ds.SourceRange;

class TagTools 
{
    public static function getRange<T:Tag>(tag:Maybe<T>):Maybe<SourceRange>
    {
        return tag.flatMap(function (t) return t.range);
    }
}
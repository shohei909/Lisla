package lisla.type.lisla.type;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.data.meta.core.WithTag;

class UnionCaseAttributes 
{
    public var headers:Array<WithTag<UnionCaseHeader>>;
    public var tag:Maybe<WithTag<Int>>;
    
    public function new(
        headers:Array<WithTag<UnionCaseHeader>>,
        tag:Maybe<WithTag<Int>>
    ) 
    {
        this.tag = tag;
        this.headers = headers;
    }
}

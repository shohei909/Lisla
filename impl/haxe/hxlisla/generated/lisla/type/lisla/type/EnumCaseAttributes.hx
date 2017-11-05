package lisla.type.lisla.type;
import haxe.ds.Option;
import lisla.data.meta.core.WithTag;

class EnumCaseAttributes 
{
    public var key:Option<WithTag<String>>;
    public var value:Option<WithTag<Value<Int>>>;
    
    public function new(
        key:Option<WithTag<String>>,
        value:Option<WithTag<Value<Int>>>
    )
    {
        this.key = key;
        this.value = value;
    }
}

package lisla.type.core;
import hxext.ds.OrderedMap;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeType;
import lisla.type.core.Tuple.Tuple2;
import lisla.type.lisla.type.TypeName;

@:forward
abstract LislaMap<Key, Value>(OrderedMap<String, Tuple2<Key, Value>>)
{ 
    public function new()
    {
        this = new OrderedMap();
    }
    
    public function add(keyString:String, key:WithTag<Key>, value:WithTag<Value>) 
    {
        this[keyString] = new Tuple2(key, value);
    }
    
}

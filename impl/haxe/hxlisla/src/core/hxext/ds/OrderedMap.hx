package hxext.ds;
import haxe.ds.StringMap;

@:multiType(@:followWithAbstracts Key)
@:forward
abstract OrderedMap<Key, Value>(OrderedMapImpl<Key, Value>) from OrderedMapImpl<Key, Value>
{
    public function new();

    @:arrayAccess private inline function _get(key:Key):Value
    {
        return this.get(key);
    }
    
    @:arrayAccess private inline function _set(key:Key, value:Value):Void
    {
        return this.set(key, value);
    }
    
	@:to static inline function toStringOrderedMap<K:String,V>(t:OrderedMapImpl<K, V>):OrderedMapImpl<K, V> 
    {
		return new OrderedMapImpl(new Map<K, V>());
	}

	@:from static inline function fromStringOrderedMap<K:String, V>(map:OrderedMapImpl<K, V>):OrderedMap<K, V> 
    {
		return cast map;
	}
    
	@:to static inline function toIntOrderedMap<K:Int,V>(t:OrderedMapImpl<K, V>):OrderedMapImpl<K, V> 
    {
		return new OrderedMapImpl(new Map<K, V>());
	}

	@:from static inline function fromIntOrderedMap<K:Int, V>(map:OrderedMapImpl<K, V>):OrderedMap<K, V> 
    {
		return cast map;
	}
    
	@:to static inline function toObjectOrderedMap<K:{}, V>(t:OrderedMapImpl<K, V>):OrderedMapImpl<K, V> 
    {
		return new OrderedMapImpl(new Map<K, V>());
	}

	@:from static inline function fromObjectOrderedMap<K:{}, V>(map:OrderedMapImpl<K, V>):OrderedMap<K, V> 
    {
		return cast map;
	}
    
	@:to static inline function toEnumValueOrderedMap<K:EnumValue, V>(t:OrderedMapImpl<K, V>):OrderedMapImpl<K, V> 
    {
		return new OrderedMapImpl(new Map<K, V>());
	}

	@:from static inline function fromEnumValueOrderedMap<K:EnumValue, V>(map:OrderedMapImpl<K, V>):OrderedMap<K, V> 
    {
		return cast map;
	}
}

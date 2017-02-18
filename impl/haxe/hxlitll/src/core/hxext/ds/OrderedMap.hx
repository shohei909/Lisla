package hxext.ds;
import haxe.ds.StringMap;

@:multiType(@:followWithAbstracts Key)
@:follow
abstract OrderedMap<Key, Value>(OrderedMapImpl<Key, Value>) 
{
    public function new();

	@:to static inline function toStringOrderedMap<K:String,V>(t:OrderedMapImpl<K, V>):OrderedMapImpl<K, V> 
    {
		return new OrderedMapImpl(new Map<K, V>());
	}

	@:from static inline function fromStringOrderedMap<V>(map:OrderedMapImpl<String, V>):OrderedMap<String, V> 
    {
		return cast map;
	}
    
	@:to static inline function toIntOrderedMap<K:Int,V>(t:OrderedMapImpl<K, V>):OrderedMapImpl<K, V> 
    {
		return new OrderedMapImpl(new Map<K, V>());
	}

	@:from static inline function fromIntOrderedMap<V>(map:OrderedMapImpl<Int, V>):OrderedMap<Int, V> 
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

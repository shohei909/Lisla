package hxext.ds;
import haxe.Constraints.IMap;

@:multiType(@:followWithAbstracts T)
abstract Set<T>(Map<T, Bool>)
{
	public function new();
    
	public inline function add(element:T):Void
	{
		this[element] = true;
	}
	
	public inline function exists(element:T):Bool
	{
		return this.exists(element);
	}
	
	public inline function remove(element:T):Bool
	{
		return this.remove(element);
	}
	
	public function iterator():Iterator<T> 
	{
		return this.keys();
	}
	
	public function toString():String 
	{
		return this.toString();
	}
    
	@:to static inline function toStringSet<T:String>(t:Map<T, Bool>):Map<String, Bool> {
		return new Map<String, Bool>();
	}

	@:from static inline function fromStringSet(map:Map<String, Bool>):Set<String> {
		return cast map;
	}
    
	@:to static inline function toEnumValueSet<T:EnumValue>(t:Map<T, Bool>):Map<T, Bool> {
		return new Map<T, Bool>();
	}

	@:from static inline function fromEnumValueSet(map:Map<EnumValue, Bool>):Set<EnumValue> {
		return cast map;
	}
    
	@:to static inline function toIntSet<T:Int>(t:Map<T, Bool>):Map<Int, Bool> {
		return new Map<Int, Bool>();
	}

	@:from static inline function fromIntSet(map:Map<Int, Bool>):Set<Int> {
		return cast map;
	}
    
	@:to static inline function toObjectSet<T:{}>(t:Map<T, Bool>):Map<T, Bool> {
		return new Map<T, Bool>();
	}

	@:from static inline function fromObjectSet(map:Map<{}, Bool>):Set<{}> {
		return cast map;
	}
}

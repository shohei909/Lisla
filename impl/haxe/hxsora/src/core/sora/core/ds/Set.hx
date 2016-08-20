package sora.core.ds;
import haxe.Constraints.IMap;

class Set<T>
{
	private var map:Map<T, Bool>;
	
	public inline function new()
	{
		this = map;
	}
	
	public inline function set(element:T):Void
	{
		map[element] = true;
	}
	
	public inline function exists(element:T):Bool
	{
		return map.exists(element);
	}
	
	public inline function remove(element:T):Bool
	{
		return map.remove(element);
	}
	
	public function iterator():Iterator<V> 
	{
		return map.keys();
	}
	
	public function toString():String 
	{
		return map.toString();
	}
}

package litll.core.ds;
import haxe.Constraints.IMap;

@:generic
class Set<T> 
{
	private var map:Map<T, Bool>;
	
	public inline function new(map:Map<T, Bool>)
	{
		this.map = map;
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
	
	public function iterator():Iterator<T> 
	{
		return map.keys();
	}
	
	public function toString():String 
	{
		return map.toString();
	}
}

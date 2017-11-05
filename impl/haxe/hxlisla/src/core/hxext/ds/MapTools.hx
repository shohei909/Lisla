package hxext.ds;
import haxe.ds.Map;
import haxe.ds.Option;

class MapTools
{
	public static inline function getMaybe<T, U>(map:Map<T, U>, key:T):Maybe<U>
	{
		return if (map.exists(key))
		{
			Maybe.some(map[key]);
		}
		else
		{
			Maybe.none();
		}
	}	
    
    public static function isEmpty<T, U>(map:Map<T, U>):Bool
    {
        return !map.iterator().hasNext();
    }
}
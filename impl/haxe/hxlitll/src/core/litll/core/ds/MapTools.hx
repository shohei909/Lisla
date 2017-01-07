package litll.core.ds;
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
}
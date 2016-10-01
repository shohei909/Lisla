package litll.core.ds;
import haxe.ds.Option;

class MapTools
{
	public static inline function getOption<T, U>(map:Map<T, U>, key:T):Option<U>
	{
		return if (map.exists(key))
		{
			Option.Some(map[key]);
		}
		else
		{
			Option.None;
		}
	}	
}
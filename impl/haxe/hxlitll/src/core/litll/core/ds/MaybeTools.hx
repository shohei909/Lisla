package litll.core.ds;
import haxe.ds.Option;

class MaybeTools
{
	public static inline function upCast<U, T:U>(maybe:Maybe<T>):Maybe<U>
	{
		return cast maybe;
	}
}
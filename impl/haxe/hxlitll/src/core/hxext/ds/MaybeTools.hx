package hxext.ds;
import haxe.ds.Option;
import hxext.ds.Maybe;

class MaybeTools
{
	public static inline function upCast<U, T:U>(maybe:Maybe<T>):Maybe<U>
	{
		return cast maybe;
	}
}
package hxext.ds;

import haxe.ds.Option;
import haxe.io.Error;

abstract Maybe<T>(Null<T>) from Null<T>
{
	public static inline function none<T>():Maybe<T>
	{
		return new Maybe(null);
	}
	public static inline function some<T>(u:T):Maybe<T>
	{
		return new Maybe(u);
	}
	
	private inline function new (t:Null<T>)
	{
		this = t;
	}
	
	public inline function isSome():Bool
	{
		return this != null;
	}
	
	public inline function isNone():Bool
	{
		return this == null;
	}
	
	public inline function iter(func:T->Void):Void
	{
		if (isSome()) func(this) else null;
	}
	
	public inline function map<U>(func:T->U):Maybe<U>
	{
		return if (isSome()) func(this) else null;
	}
	
	public inline function flatMap<U>(func:T->Maybe<U>):Maybe<U>
	{
		return if (isSome()) func(this) else null;
	}
	
	public inline function getOrThrow<U>(error:Void->U):T
	{
		return if (isSome()) this else throw error();
	}
	
	public inline function getOrElse(elseValue:T):T
	{
		return if (isSome()) this else elseValue;
	}
	
	public inline function getOrCall(callee:Void->T):T
	{
		return if (isSome()) this else callee();
	}
	
	public inline function toOption():Option<T>
	{
		return if (isSome()) Option.Some(this) else Option.None;
	}
	
	public inline function toArray():Array<T>
	{
		return if (isSome()) [this] else [];
	}
    
	public inline static function fromOption<T>(option:Option<T>):Maybe<T>
	{
		return switch (option)
		{
			case Option.Some(v):
				Maybe.some(v);
				
			case Option.None:
				Maybe.none();
		}
	}
    
    @:impl
	public static inline function upCast<U, T:U>(maybe:Maybe<T>):Maybe<U>
	{
		return cast maybe;
	}
    
    @:impl
	public static inline function mapAll<T, U>(maybe:Maybe<Array<T>>, func:T->U):Maybe<Array<U>>
	{
		return maybe.map(function (arr) return [for (e in arr) func(e)]);
	}
    
	public inline function match<U>(
        onSome: T -> U,
        onNone: Void -> U
    ):U
	{
		return if (isSome())
        {
            onSome(this);
        }
        else
        {
            onNone();
        }
	}
}

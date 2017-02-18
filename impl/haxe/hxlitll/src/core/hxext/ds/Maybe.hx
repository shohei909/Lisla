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
}

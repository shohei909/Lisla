package hxext.ds;
import haxe.ds.Option;

class OptionTools 
{    
	public static inline function isSome<T>(option:Option<T>):Bool
	{
		return option.match(Option.Some(_));
	}
	
	public static inline function isNone<T>(option:Option<T>):Bool
	{
		return option.match(Option.None);
	}
	
	public static inline function iter<T>(option:Option<T>, func:T->Void):Void
	{
		switch option
        {
            case Option.Some(t): func(t);
            case Option.None:
        }
	}
	
	public static inline function map<T, U>(option:Option<T>, func:T->U):Option<U>
	{
		return switch option
        {
            case Option.Some(t): Option.Some(func(t));
            case Option.None: Option.None;
        }
	}
	
	public static inline function flatMap<T, U>(option:Option<T>, func:T->Option<U>):Option<U>
	{
		return switch option
        {
            case Option.Some(t): func(t);
            case Option.None: Option.None;
        }
	}
	
	public static inline function getOrThrow<T, U>(option:Option<T>, error:Void->U):T
	{
        return switch option
        {
            case Option.Some(t): t;
            case Option.None: throw error();
        }
	}
	
	public static inline function getOrElse<T>(option:Option<T>, elseValue:T):T
	{
        return switch option
        {
            case Option.Some(t): t;
            case Option.None: elseValue;
        }
	}
	
	public static inline function getOrCall<T>(option:Option<T>, callee:Void->T):T
	{
        return switch option
        {
            case Option.Some(t): t;
            case Option.None: callee();
        }
	}
}
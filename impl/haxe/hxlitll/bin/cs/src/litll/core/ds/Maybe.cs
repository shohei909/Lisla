// Generated by Haxe 3.4.0

#pragma warning disable 109, 114, 219, 429, 168, 162
namespace litll.core.ds._Maybe {
	public sealed class Maybe_Impl_ {
		
		public static global::haxe.lang.Null<T> none<T>() {
			return global::litll.core.ds._Maybe.Maybe_Impl_._new<T>(default(global::haxe.lang.Null<T>));
		}
		
		
		public static global::haxe.lang.Null<T> some<T>(T u) {
			return global::litll.core.ds._Maybe.Maybe_Impl_._new<T>(new global::haxe.lang.Null<T>(u, true));
		}
		
		
		public static global::haxe.lang.Null<T> _new<T>(global::haxe.lang.Null<T> t) {
			return ((global::haxe.lang.Null<T>) (t) );
		}
		
		
		public static bool isSome<T>(global::haxe.lang.Null<T> this1) {
			return this1.hasValue;
		}
		
		
		public static bool isNone<T>(global::haxe.lang.Null<T> this1) {
			return  ! (this1.hasValue) ;
		}
		
		
		public static void iter<T>(global::haxe.lang.Null<T> this1, global::haxe.lang.Function func) {
			if (global::litll.core.ds._Maybe.Maybe_Impl_.isSome<T>(((global::haxe.lang.Null<T>) (this1) ))) {
				func.__hx_invoke1_o(default(double), (this1).toDynamic());
			}
			
		}
		
		
		public static global::haxe.lang.Null<U> map<U, T>(global::haxe.lang.Null<T> this1, global::haxe.lang.Function func) {
			if (global::litll.core.ds._Maybe.Maybe_Impl_.isSome<T>(((global::haxe.lang.Null<T>) (this1) ))) {
				return new global::haxe.lang.Null<U>(global::haxe.lang.Runtime.genericCast<U>(func.__hx_invoke1_o(default(double), (this1).toDynamic())), true);
			}
			else {
				return default(global::haxe.lang.Null<U>);
			}
			
		}
		
		
		public static global::haxe.lang.Null<U> flatMap<U, T>(global::haxe.lang.Null<T> this1, global::haxe.lang.Function func) {
			if (global::litll.core.ds._Maybe.Maybe_Impl_.isSome<T>(((global::haxe.lang.Null<T>) (this1) ))) {
				return global::haxe.lang.Null<object>.ofDynamic<U>(func.__hx_invoke1_o(default(double), (this1).toDynamic()));
			}
			else {
				return default(global::haxe.lang.Null<U>);
			}
			
		}
		
		
		public static T getOrThrow<U, T>(global::haxe.lang.Null<T> this1, global::haxe.lang.Function error) {
			if (global::litll.core.ds._Maybe.Maybe_Impl_.isSome<T>(((global::haxe.lang.Null<T>) (this1) ))) {
				return (this1).@value;
			}
			else {
				throw global::haxe.lang.HaxeException.wrap(global::haxe.lang.Runtime.genericCast<U>(error.__hx_invoke0_o()));
			}
			
		}
		
		
		public static T getOrElse<T>(global::haxe.lang.Null<T> this1, T elseValue) {
			if (global::litll.core.ds._Maybe.Maybe_Impl_.isSome<T>(((global::haxe.lang.Null<T>) (this1) ))) {
				return (this1).@value;
			}
			else {
				return elseValue;
			}
			
		}
		
		
		public static T getOrCall<T>(global::haxe.lang.Null<T> this1, global::haxe.lang.Function callee) {
			if (global::litll.core.ds._Maybe.Maybe_Impl_.isSome<T>(((global::haxe.lang.Null<T>) (this1) ))) {
				return (this1).@value;
			}
			else {
				return global::haxe.lang.Runtime.genericCast<T>(callee.__hx_invoke0_o());
			}
			
		}
		
		
		public static global::haxe.ds.Option toOption<T>(global::haxe.lang.Null<T> this1) {
			if (global::litll.core.ds._Maybe.Maybe_Impl_.isSome<T>(((global::haxe.lang.Null<T>) (this1) ))) {
				return global::haxe.ds.Option.Some((this1).toDynamic());
			}
			else {
				return global::haxe.ds.Option.None;
			}
			
		}
		
		
		public static global::haxe.lang.Null<T> fromOption<T>(global::haxe.ds.Option option) {
			unchecked {
				switch (option.index) {
					case 0:
					{
						return global::litll.core.ds._Maybe.Maybe_Impl_._new<T>(new global::haxe.lang.Null<T>(global::haxe.lang.Runtime.genericCast<T>(option.@params[0]), true));
					}
					
					
					case 1:
					{
						return global::litll.core.ds._Maybe.Maybe_Impl_._new<T>(default(global::haxe.lang.Null<T>));
					}
					
					
				}
				
				return default(global::haxe.lang.Null<T>);
			}
		}
		
		
	}
}



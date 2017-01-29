// Generated by Haxe 3.4.0

#pragma warning disable 109, 114, 219, 429, 168, 162
namespace unifill {
	public class Exception : global::haxe.lang.HxObject {
		
		public Exception(global::haxe.lang.EmptyObject empty) {
		}
		
		
		public Exception() {
			global::unifill.Exception.__hx_ctor_unifill_Exception(this);
		}
		
		
		public static void __hx_ctor_unifill_Exception(global::unifill.Exception __hx_this) {
		}
		
		
		public virtual string toString() {
			throw global::haxe.lang.HaxeException.wrap(null);
		}
		
		
		public override object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 946786476:
					{
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(this, "toString", 946786476)) );
					}
					
					
					default:
					{
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
		}
		
		
		public override object __hx_invokeField(string field, int hash, global::Array dynargs) {
			unchecked {
				switch (hash) {
					case 946786476:
					{
						return this.toString();
					}
					
					
					default:
					{
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
			}
		}
		
		
		public override string ToString(){
			return this.toString();
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace unifill {
	public class InvalidCodePoint : global::unifill.Exception {
		
		public InvalidCodePoint(global::haxe.lang.EmptyObject empty) : base(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) )) {
		}
		
		
		public InvalidCodePoint(int code) : base(global::haxe.lang.EmptyObject.EMPTY) {
			global::unifill.InvalidCodePoint.__hx_ctor_unifill_InvalidCodePoint(this, code);
		}
		
		
		public static void __hx_ctor_unifill_InvalidCodePoint(global::unifill.InvalidCodePoint __hx_this, int code) {
			global::unifill.Exception.__hx_ctor_unifill_Exception(__hx_this);
			__hx_this.code = code;
		}
		
		
		public int code;
		
		public override string toString() {
			return global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat("InvalidCodePoint(code: ", global::haxe.lang.Runtime.toString(this.code)), ")");
		}
		
		
		public override double __hx_setField_f(string field, int hash, double @value, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 1103409453:
					{
						this.code = ((int) (@value) );
						return @value;
					}
					
					
					default:
					{
						return base.__hx_setField_f(field, hash, @value, handleProperties);
					}
					
				}
				
			}
		}
		
		
		public override object __hx_setField(string field, int hash, object @value, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 1103409453:
					{
						this.code = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						return @value;
					}
					
					
					default:
					{
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
		}
		
		
		public override object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 946786476:
					{
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(this, "toString", 946786476)) );
					}
					
					
					case 1103409453:
					{
						return this.code;
					}
					
					
					default:
					{
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
		}
		
		
		public override double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 1103409453:
					{
						return ((double) (this.code) );
					}
					
					
					default:
					{
						return base.__hx_getField_f(field, hash, throwErrors, handleProperties);
					}
					
				}
				
			}
		}
		
		
		public override void __hx_getFields(global::Array<object> baseArr) {
			baseArr.push("code");
			base.__hx_getFields(baseArr);
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace unifill {
	public class InvalidCodeUnitSequence : global::unifill.Exception {
		
		public InvalidCodeUnitSequence(global::haxe.lang.EmptyObject empty) : base(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) )) {
		}
		
		
		public InvalidCodeUnitSequence(int index) : base(global::haxe.lang.EmptyObject.EMPTY) {
			global::unifill.InvalidCodeUnitSequence.__hx_ctor_unifill_InvalidCodeUnitSequence(this, index);
		}
		
		
		public static void __hx_ctor_unifill_InvalidCodeUnitSequence(global::unifill.InvalidCodeUnitSequence __hx_this, int index) {
			global::unifill.Exception.__hx_ctor_unifill_Exception(__hx_this);
			__hx_this.index = index;
		}
		
		
		public int index;
		
		public override string toString() {
			return global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat("InvalidCodeUnitSequence(index: ", global::haxe.lang.Runtime.toString(this.index)), ")");
		}
		
		
		public override double __hx_setField_f(string field, int hash, double @value, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 1041537810:
					{
						this.index = ((int) (@value) );
						return @value;
					}
					
					
					default:
					{
						return base.__hx_setField_f(field, hash, @value, handleProperties);
					}
					
				}
				
			}
		}
		
		
		public override object __hx_setField(string field, int hash, object @value, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 1041537810:
					{
						this.index = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						return @value;
					}
					
					
					default:
					{
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
		}
		
		
		public override object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 946786476:
					{
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(this, "toString", 946786476)) );
					}
					
					
					case 1041537810:
					{
						return this.index;
					}
					
					
					default:
					{
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
		}
		
		
		public override double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 1041537810:
					{
						return ((double) (this.index) );
					}
					
					
					default:
					{
						return base.__hx_getField_f(field, hash, throwErrors, handleProperties);
					}
					
				}
				
			}
		}
		
		
		public override void __hx_getFields(global::Array<object> baseArr) {
			baseArr.push("index");
			base.__hx_getFields(baseArr);
		}
		
		
	}
}



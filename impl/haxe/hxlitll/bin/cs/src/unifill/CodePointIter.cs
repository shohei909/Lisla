// Generated by Haxe 3.4.0

#pragma warning disable 109, 114, 219, 429, 168, 162
namespace unifill {
	public class CodePointIter : global::haxe.lang.HxObject {
		
		public CodePointIter(global::haxe.lang.EmptyObject empty) {
		}
		
		
		public CodePointIter(string s) {
			global::unifill.CodePointIter.__hx_ctor_unifill_CodePointIter(this, s);
		}
		
		
		public static void __hx_ctor_unifill_CodePointIter(global::unifill.CodePointIter __hx_this, string s) {
			__hx_this.i = 0;
			__hx_this.@string = s;
			__hx_this.index = 0;
			__hx_this.endIndex = s.Length;
		}
		
		
		public string @string;
		
		public int index;
		
		public int endIndex;
		
		public bool hasNext() {
			return ( this.index < this.endIndex );
		}
		
		
		public int i;
		
		public int next() {
			unchecked {
				this.i = this.index;
				int index = this.index;
				string s = ((string) (this.@string) );
				int c = ( (((bool) (( ((uint) (index) ) < ((string) (s) ).Length )) )) ? (((int) (((string) (s) )[index]) )) : (-1) );
				this.index += ( ( ! ((( ( 55296 <= c ) && ( c <= 56319 ) ))) ) ? (1) : (2) );
				return ((int) (global::unifill._Utf16.Utf16_Impl_.codePointAt(((string) (this.@string) ), this.i)) );
			}
		}
		
		
		public override double __hx_setField_f(string field, int hash, double @value, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 105:
					{
						this.i = ((int) (@value) );
						return @value;
					}
					
					
					case 1007824183:
					{
						this.endIndex = ((int) (@value) );
						return @value;
					}
					
					
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
					case 105:
					{
						this.i = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						return @value;
					}
					
					
					case 1007824183:
					{
						this.endIndex = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						return @value;
					}
					
					
					case 1041537810:
					{
						this.index = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						return @value;
					}
					
					
					case 288368849:
					{
						this.@string = global::haxe.lang.Runtime.toString(@value);
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
					case 1224901875:
					{
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(this, "next", 1224901875)) );
					}
					
					
					case 105:
					{
						return this.i;
					}
					
					
					case 407283053:
					{
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(this, "hasNext", 407283053)) );
					}
					
					
					case 1007824183:
					{
						return this.endIndex;
					}
					
					
					case 1041537810:
					{
						return this.index;
					}
					
					
					case 288368849:
					{
						return this.@string;
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
					case 105:
					{
						return ((double) (this.i) );
					}
					
					
					case 1007824183:
					{
						return ((double) (this.endIndex) );
					}
					
					
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
		
		
		public override object __hx_invokeField(string field, int hash, global::Array dynargs) {
			unchecked {
				switch (hash) {
					case 1224901875:
					{
						return this.next();
					}
					
					
					case 407283053:
					{
						return this.hasNext();
					}
					
					
					default:
					{
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
			}
		}
		
		
		public override void __hx_getFields(global::Array<object> baseArr) {
			baseArr.push("i");
			baseArr.push("endIndex");
			baseArr.push("index");
			baseArr.push("string");
			base.__hx_getFields(baseArr);
		}
		
		
	}
}



// Generated by Haxe 3.4.0

#pragma warning disable 109, 114, 219, 429, 168, 162
namespace litll.core.ds {
	public class SourceRange : global::haxe.lang.HxObject {
		
		public SourceRange(global::haxe.lang.EmptyObject empty) {
		}
		
		
		public SourceRange(global::litll.core.ds.SourceMap map, int low, int high) {
			global::litll.core.ds.SourceRange.__hx_ctor_litll_core_ds_SourceRange(this, map, low, high);
		}
		
		
		public static void __hx_ctor_litll_core_ds_SourceRange(global::litll.core.ds.SourceRange __hx_this, global::litll.core.ds.SourceMap map, int low, int high) {
			__hx_this.map = map;
			__hx_this.low = low;
			__hx_this.high = high;
		}
		
		
		public global::litll.core.ds.SourceMap map;
		
		public int low;
		
		public int high;
		
		public virtual bool contains(int @value) {
			if (( this.low <= @value )) {
				return ( @value < this.high );
			}
			else {
				return false;
			}
			
		}
		
		
		public virtual string toString() {
			unchecked {
				global::litll.core.ds.SourceMap _this = this.map;
				int targetInner = this.low;
				int targetIndex = global::litll.core.math.SearchTools.binarySearch<object>(((global::Array<object>) (_this.lines) ), ((double) (targetInner) ), ((global::haxe.lang.Function) (( (( global::litll.core.ds.SourceRange_toString_26__Fun.__hx_current != null )) ? (global::litll.core.ds.SourceRange_toString_26__Fun.__hx_current) : (global::litll.core.ds.SourceRange_toString_26__Fun.__hx_current = ((global::litll.core.ds.SourceRange_toString_26__Fun) (new global::litll.core.ds.SourceRange_toString_26__Fun()) )) )) ));
				global::litll.core.ds.SourcePosition lowPosition = null;
				if (( targetIndex == -1 )) {
					global::litll.core.ds.LinePosition line1 = ((global::litll.core.ds.LinePosition) (_this.lines[0]) );
					lowPosition = new global::litll.core.ds.SourcePosition(line1.outerLine, line1.padding, line1.outerIndex);
				}
				else {
					global::litll.core.ds.LinePosition line2 = ((global::litll.core.ds.LinePosition) (_this.lines[targetIndex]) );
					int offset = ( targetInner - line2.innerIndex );
					lowPosition = new global::litll.core.ds.SourcePosition(line2.outerLine, ( line2.padding + offset ), ( line2.outerIndex + offset ));
				}
				
				global::litll.core.ds.SourceMap _this1 = this.map;
				int targetInner1 = this.high;
				int targetIndex1 = global::litll.core.math.SearchTools.binarySearch<object>(((global::Array<object>) (_this1.lines) ), ((double) (targetInner1) ), ((global::haxe.lang.Function) (( (( global::litll.core.ds.SourceRange_toString_27__Fun.__hx_current != null )) ? (global::litll.core.ds.SourceRange_toString_27__Fun.__hx_current) : (global::litll.core.ds.SourceRange_toString_27__Fun.__hx_current = ((global::litll.core.ds.SourceRange_toString_27__Fun) (new global::litll.core.ds.SourceRange_toString_27__Fun()) )) )) ));
				global::litll.core.ds.SourcePosition highPosition = null;
				if (( targetIndex1 == -1 )) {
					global::litll.core.ds.LinePosition line4 = ((global::litll.core.ds.LinePosition) (_this1.lines[0]) );
					highPosition = new global::litll.core.ds.SourcePosition(line4.outerLine, line4.padding, line4.outerIndex);
				}
				else {
					global::litll.core.ds.LinePosition line5 = ((global::litll.core.ds.LinePosition) (_this1.lines[targetIndex1]) );
					int offset1 = ( targetInner1 - line5.innerIndex );
					highPosition = new global::litll.core.ds.SourcePosition(line5.outerLine, ( line5.padding + offset1 ), ( line5.outerIndex + offset1 ));
				}
				
				return global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat("line:", global::haxe.lang.Runtime.toString(lowPosition.line)), ":"), global::haxe.lang.Runtime.toString(lowPosition.row)), "("), global::haxe.lang.Runtime.toString(lowPosition.index)), ")"), "-"), (global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat("line:", global::haxe.lang.Runtime.toString(highPosition.line)), ":"), global::haxe.lang.Runtime.toString(highPosition.row)), "("), global::haxe.lang.Runtime.toString(highPosition.index)), ")")));
			}
		}
		
		
		public virtual global::litll.core.ds.SourceRange concat(global::litll.core.ds.SourceRange child) {
			unchecked {
				global::litll.core.ds.SourceMap tmp = this.map;
				global::litll.core.ds.SourceMap _this = child.map;
				int targetInner = child.low;
				int targetIndex = global::litll.core.math.SearchTools.binarySearch<object>(((global::Array<object>) (_this.lines) ), ((double) (targetInner) ), ((global::haxe.lang.Function) (( (( global::litll.core.ds.SourceRange_concat_36__Fun.__hx_current != null )) ? (global::litll.core.ds.SourceRange_concat_36__Fun.__hx_current) : (global::litll.core.ds.SourceRange_concat_36__Fun.__hx_current = ((global::litll.core.ds.SourceRange_concat_36__Fun) (new global::litll.core.ds.SourceRange_concat_36__Fun()) )) )) ));
				global::litll.core.ds.SourcePosition tmp1 = null;
				if (( targetIndex == -1 )) {
					global::litll.core.ds.LinePosition line1 = ((global::litll.core.ds.LinePosition) (_this.lines[0]) );
					tmp1 = new global::litll.core.ds.SourcePosition(line1.outerLine, line1.padding, line1.outerIndex);
				}
				else {
					global::litll.core.ds.LinePosition line2 = ((global::litll.core.ds.LinePosition) (_this.lines[targetIndex]) );
					int offset = ( targetInner - line2.innerIndex );
					tmp1 = new global::litll.core.ds.SourcePosition(line2.outerLine, ( line2.padding + offset ), ( line2.outerIndex + offset ));
				}
				
				int tmp2 = tmp1.index;
				global::litll.core.ds.SourceMap _this1 = child.map;
				int targetInner1 = child.high;
				int targetIndex1 = global::litll.core.math.SearchTools.binarySearch<object>(((global::Array<object>) (_this1.lines) ), ((double) (targetInner1) ), ((global::haxe.lang.Function) (( (( global::litll.core.ds.SourceRange_concat_37__Fun.__hx_current != null )) ? (global::litll.core.ds.SourceRange_concat_37__Fun.__hx_current) : (global::litll.core.ds.SourceRange_concat_37__Fun.__hx_current = ((global::litll.core.ds.SourceRange_concat_37__Fun) (new global::litll.core.ds.SourceRange_concat_37__Fun()) )) )) ));
				global::litll.core.ds.SourcePosition tmp3 = null;
				if (( targetIndex1 == -1 )) {
					global::litll.core.ds.LinePosition line4 = ((global::litll.core.ds.LinePosition) (_this1.lines[0]) );
					tmp3 = new global::litll.core.ds.SourcePosition(line4.outerLine, line4.padding, line4.outerIndex);
				}
				else {
					global::litll.core.ds.LinePosition line5 = ((global::litll.core.ds.LinePosition) (_this1.lines[targetIndex1]) );
					int offset1 = ( targetInner1 - line5.innerIndex );
					tmp3 = new global::litll.core.ds.SourcePosition(line5.outerLine, ( line5.padding + offset1 ), ( line5.outerIndex + offset1 ));
				}
				
				return new global::litll.core.ds.SourceRange(tmp, tmp2, tmp3.index);
			}
		}
		
		
		public override double __hx_setField_f(string field, int hash, double @value, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 1158559586:
					{
						this.high = ((int) (@value) );
						return @value;
					}
					
					
					case 5395604:
					{
						this.low = ((int) (@value) );
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
					case 1158559586:
					{
						this.high = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						return @value;
					}
					
					
					case 5395604:
					{
						this.low = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						return @value;
					}
					
					
					case 5442204:
					{
						this.map = ((global::litll.core.ds.SourceMap) (@value) );
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
					case 1204816148:
					{
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(this, "concat", 1204816148)) );
					}
					
					
					case 946786476:
					{
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(this, "toString", 946786476)) );
					}
					
					
					case 746281503:
					{
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(this, "contains", 746281503)) );
					}
					
					
					case 1158559586:
					{
						return this.high;
					}
					
					
					case 5395604:
					{
						return this.low;
					}
					
					
					case 5442204:
					{
						return this.map;
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
					case 1158559586:
					{
						return ((double) (this.high) );
					}
					
					
					case 5395604:
					{
						return ((double) (this.low) );
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
					case 1204816148:
					{
						return this.concat(((global::litll.core.ds.SourceRange) (dynargs[0]) ));
					}
					
					
					case 946786476:
					{
						return this.toString();
					}
					
					
					case 746281503:
					{
						return this.contains(((int) (global::haxe.lang.Runtime.toInt(dynargs[0])) ));
					}
					
					
					default:
					{
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
			}
		}
		
		
		public override void __hx_getFields(global::Array<object> baseArr) {
			baseArr.push("high");
			baseArr.push("low");
			baseArr.push("map");
			base.__hx_getFields(baseArr);
		}
		
		
		public override string ToString(){
			return this.toString();
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace litll.core.ds {
	public class SourceRange_toString_26__Fun : global::haxe.lang.Function {
		
		public SourceRange_toString_26__Fun() : base(1, 1) {
		}
		
		
		public static global::litll.core.ds.SourceRange_toString_26__Fun __hx_current;
		
		public override double __hx_invoke1_f(double __fn_float1, object __fn_dyn1) {
			global::litll.core.ds.LinePosition line = ( (( __fn_dyn1 == global::haxe.lang.Runtime.undefined )) ? (((global::litll.core.ds.LinePosition) (((object) (__fn_float1) )) )) : (((global::litll.core.ds.LinePosition) (__fn_dyn1) )) );
			return ((double) (line.innerIndex) );
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace litll.core.ds {
	public class SourceRange_toString_27__Fun : global::haxe.lang.Function {
		
		public SourceRange_toString_27__Fun() : base(1, 1) {
		}
		
		
		public static global::litll.core.ds.SourceRange_toString_27__Fun __hx_current;
		
		public override double __hx_invoke1_f(double __fn_float1, object __fn_dyn1) {
			global::litll.core.ds.LinePosition line3 = ( (( __fn_dyn1 == global::haxe.lang.Runtime.undefined )) ? (((global::litll.core.ds.LinePosition) (((object) (__fn_float1) )) )) : (((global::litll.core.ds.LinePosition) (__fn_dyn1) )) );
			return ((double) (line3.innerIndex) );
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace litll.core.ds {
	public class SourceRange_concat_36__Fun : global::haxe.lang.Function {
		
		public SourceRange_concat_36__Fun() : base(1, 1) {
		}
		
		
		public static global::litll.core.ds.SourceRange_concat_36__Fun __hx_current;
		
		public override double __hx_invoke1_f(double __fn_float1, object __fn_dyn1) {
			global::litll.core.ds.LinePosition line = ( (( __fn_dyn1 == global::haxe.lang.Runtime.undefined )) ? (((global::litll.core.ds.LinePosition) (((object) (__fn_float1) )) )) : (((global::litll.core.ds.LinePosition) (__fn_dyn1) )) );
			return ((double) (line.innerIndex) );
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace litll.core.ds {
	public class SourceRange_concat_37__Fun : global::haxe.lang.Function {
		
		public SourceRange_concat_37__Fun() : base(1, 1) {
		}
		
		
		public static global::litll.core.ds.SourceRange_concat_37__Fun __hx_current;
		
		public override double __hx_invoke1_f(double __fn_float1, object __fn_dyn1) {
			global::litll.core.ds.LinePosition line3 = ( (( __fn_dyn1 == global::haxe.lang.Runtime.undefined )) ? (((global::litll.core.ds.LinePosition) (((object) (__fn_float1) )) )) : (((global::litll.core.ds.LinePosition) (__fn_dyn1) )) );
			return ((double) (line3.innerIndex) );
		}
		
		
	}
}



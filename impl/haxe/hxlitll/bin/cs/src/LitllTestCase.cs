// Generated by Haxe 3.4.0

#pragma warning disable 109, 114, 219, 429, 168, 162
public class LitllTestCase : global::nanotest.NanoTestCase {
	
	public LitllTestCase(global::haxe.lang.EmptyObject empty) : base(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) )) {
	}
	
	
	public LitllTestCase(object posInfos) : base(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) )) {
		global::LitllTestCase.__hx_ctor__LitllTestCase(this, posInfos);
	}
	
	
	public static void __hx_ctor__LitllTestCase(global::LitllTestCase __hx_this, object posInfos) {
		global::nanotest.NanoTestCase.__hx_ctor_nanotest_NanoTestCase(__hx_this, posInfos);
	}
	
	
	public virtual void assertLitllArray(global::litll.core.LitllArray<object> litll, object json, string path, object pos) {
		if (string.Equals(path, null)) {
			path = "_";
		}
		
		if ( ! (( json is global::Array )) ) {
			this.fail(global::haxe.lang.Runtime.concat(global::Std.@string(json), " must be array"), pos);
			return;
		}
		
		global::Array jsonArray = ((global::Array) (json) );
		this.assertEquals<int>(((int) (global::haxe.lang.Runtime.getField_f(jsonArray, "length", 520590566, true)) ), ((int) (litll.data.length) ), ((object) (pos) )).label(global::haxe.lang.Runtime.concat(path, ".length"));
		{
			int _g1 = 0;
			int _g = ((int) (global::haxe.lang.Runtime.getField_f(jsonArray, "length", 520590566, true)) );
			while (( _g1 < _g )) {
				int i = _g1++;
				this.assertLitll(((global::litll.core.Litll) (litll.data[i]) ), jsonArray[i], global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(path, "["), global::haxe.lang.Runtime.toString(i)), "]"), pos);
			}
			
		}
		
	}
	
	
	public virtual void assertLitll(global::litll.core.Litll litll, object json, string path, object pos) {
		unchecked {
			if (string.Equals(path, null)) {
				path = "_";
			}
			
			switch (litll.index) {
				case 0:
				{
					this.assertLitllArray(((global::litll.core.LitllArray<object>) (global::litll.core.LitllArray<object>.__hx_cast<object>(((global::litll.core.LitllArray) (litll.@params[0]) ))) ), json, path, pos);
					break;
				}
				
				
				case 1:
				{
					this.assertLitllString(((global::litll.core.LitllString) (litll.@params[0]) ), json, path, pos);
					break;
				}
				
				
			}
			
		}
	}
	
	
	public virtual void assertLitllString(global::litll.core.LitllString litll, object json, string path, object pos) {
		if (string.Equals(path, null)) {
			path = "_";
		}
		
		if ( ! (( json is string )) ) {
			this.fail(global::haxe.lang.Runtime.concat(global::Std.@string(json), " must be string"), pos);
			return;
		}
		
		this.assertEquals<object>(((object) (json) ), ((object) (litll.data) ), ((object) (pos) )).label(path);
	}
	
	
	public override object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties) {
		unchecked {
			switch (hash) {
				case 1459008674:
				{
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(this, "assertLitllString", 1459008674)) );
				}
				
				
				case 2000440561:
				{
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(this, "assertLitll", 2000440561)) );
				}
				
				
				case 57607912:
				{
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(this, "assertLitllArray", 57607912)) );
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
				case 1459008674:
				{
					this.assertLitllString(((global::litll.core.LitllString) (dynargs[0]) ), dynargs[1], global::haxe.lang.Runtime.toString(dynargs[2]), dynargs[3]);
					break;
				}
				
				
				case 2000440561:
				{
					this.assertLitll(((global::litll.core.Litll) (dynargs[0]) ), dynargs[1], global::haxe.lang.Runtime.toString(dynargs[2]), dynargs[3]);
					break;
				}
				
				
				case 57607912:
				{
					this.assertLitllArray(((global::litll.core.LitllArray<object>) (global::litll.core.LitllArray<object>.__hx_cast<object>(((global::litll.core.LitllArray) (dynargs[0]) ))) ), dynargs[1], global::haxe.lang.Runtime.toString(dynargs[2]), dynargs[3]);
					break;
				}
				
				
				default:
				{
					return base.__hx_invokeField(field, hash, dynargs);
				}
				
			}
			
			return null;
		}
	}
	
	
}



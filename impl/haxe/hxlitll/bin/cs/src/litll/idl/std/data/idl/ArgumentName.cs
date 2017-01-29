// Generated by Haxe 3.4.0

#pragma warning disable 109, 114, 219, 429, 168, 162
namespace litll.idl.std.data.idl {
	public class ArgumentName : global::haxe.lang.HxObject {
		
		public ArgumentName(global::haxe.lang.EmptyObject empty) {
		}
		
		
		public ArgumentName(string name, global::litll.core.tag.StringTag tag) {
			global::litll.idl.std.data.idl.ArgumentName.__hx_ctor_litll_idl_std_data_idl_ArgumentName(this, name, tag);
		}
		
		
		public static void __hx_ctor_litll_idl_std_data_idl_ArgumentName(global::litll.idl.std.data.idl.ArgumentName __hx_this, string name, global::litll.core.tag.StringTag tag) {
			unchecked {
				if (name.EndsWith("..")) {
					name = global::haxe.lang.StringExt.substr(name, 0, new global::haxe.lang.Null<int>(( name.Length - 2 ), true));
					__hx_this.kind = global::litll.idl.std.data.idl.ArgumentKind.Rest;
				}
				else if (name.EndsWith("?")) {
					name = global::haxe.lang.StringExt.substr(name, 0, new global::haxe.lang.Null<int>(( name.Length - 1 ), true));
					__hx_this.kind = global::litll.idl.std.data.idl.ArgumentKind.Optional;
				}
				else if (name.EndsWith("<")) {
					name = global::haxe.lang.StringExt.substr(name, 0, new global::haxe.lang.Null<int>(( name.Length - 1 ), true));
					__hx_this.kind = global::litll.idl.std.data.idl.ArgumentKind.Unfold;
				}
				else {
					__hx_this.kind = global::litll.idl.std.data.idl.ArgumentKind.Normal;
				}
				
				if ( ! (global::litll.core.@string.IdentifierTools.isSnakeCase(name)) ) {
					throw global::haxe.lang.HaxeException.wrap("argument name must be snake case name");
				}
				
				__hx_this.name = name;
			}
		}
		
		
		public static global::litll.core.ds.Result delitllfy(global::litll.core.LitllString @string) {
			unchecked {
				global::litll.core.ds.Result _g = global::litll.idl.std.data.idl.ArgumentName.create(@string.data, @string.tag);
				switch (_g.index) {
					case 0:
					{
						return global::litll.core.ds.Result.Ok(((global::litll.idl.std.data.idl.ArgumentName) (_g.@params[0]) ));
					}
					
					
					case 1:
					{
						return global::litll.core.ds.Result.Err(global::litll.idl.delitllfy.DelitllfyErrorKind.Fatal(global::haxe.lang.Runtime.toString(_g.@params[0])));
					}
					
					
				}
				
				return null;
			}
		}
		
		
		public static global::litll.core.ds.Result create(string @string, global::litll.core.tag.StringTag tag) {
			try {
				return global::litll.core.ds.Result.Ok(new global::litll.idl.std.data.idl.ArgumentName(@string, tag));
			}
			catch (global::System.Exception __temp_catchallException1){
				global::haxe.lang.Exceptions.exception = __temp_catchallException1;
				object __temp_catchall2 = __temp_catchallException1;
				if (( __temp_catchall2 is global::haxe.lang.HaxeException )) {
					__temp_catchall2 = ((global::haxe.lang.HaxeException) (__temp_catchallException1) ).obj;
				}
				
				if (( __temp_catchall2 is string )) {
					string err = global::haxe.lang.Runtime.toString(__temp_catchall2);
					{
						return global::litll.core.ds.Result.Err(err);
					}
					
				}
				else {
					throw;
				}
				
			}
			
			
			return null;
		}
		
		
		public global::litll.idl.std.data.idl.ArgumentKind kind;
		
		public string name;
		
		public global::litll.core.tag.StringTag tag;
		
		public virtual global::litll.core.ds.Result toVariableName() {
			unchecked {
				global::litll.core.ds.Result result = global::litll.core.@string.IdentifierTools.toCamelCase(this.name);
				switch (result.index) {
					case 0:
					{
						return global::litll.core.ds.Result.Ok(global::litll.core.@string.IdentifierTools.escapeKeyword(global::haxe.lang.Runtime.toString(result.@params[0])));
					}
					
					
					case 1:
					{
						return global::litll.core.ds.Result.Err(global::haxe.lang.Runtime.toString(result.@params[0]));
					}
					
					
				}
				
				return null;
			}
		}
		
		
		public override object __hx_setField(string field, int hash, object @value, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 5790298:
					{
						this.tag = ((global::litll.core.tag.StringTag) (@value) );
						return @value;
					}
					
					
					case 1224700491:
					{
						this.name = global::haxe.lang.Runtime.toString(@value);
						return @value;
					}
					
					
					case 1191829844:
					{
						this.kind = ((global::litll.idl.std.data.idl.ArgumentKind) (@value) );
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
					case 653524162:
					{
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(this, "toVariableName", 653524162)) );
					}
					
					
					case 5790298:
					{
						return this.tag;
					}
					
					
					case 1224700491:
					{
						return this.name;
					}
					
					
					case 1191829844:
					{
						return this.kind;
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
					case 653524162:
					{
						return this.toVariableName();
					}
					
					
					default:
					{
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
			}
		}
		
		
		public override void __hx_getFields(global::Array<object> baseArr) {
			baseArr.push("tag");
			baseArr.push("name");
			baseArr.push("kind");
			base.__hx_getFields(baseArr);
		}
		
		
	}
}



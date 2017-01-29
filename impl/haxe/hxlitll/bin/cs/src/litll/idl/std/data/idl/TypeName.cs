// Generated by Haxe 3.4.0

#pragma warning disable 109, 114, 219, 429, 168, 162
namespace litll.idl.std.data.idl._TypeName {
	public sealed class TypeName_Impl_ {
		
		static TypeName_Impl_() {
			global::litll.idl.std.data.idl._TypeName.TypeName_Impl_.headEReg = new global::EReg("[A-Z]", "");
			global::litll.idl.std.data.idl._TypeName.TypeName_Impl_.bodyEReg = new global::EReg("[0-9a-zA-Z]*", "");
		}
		
		
		public static global::EReg headEReg;
		
		public static global::EReg bodyEReg;
		
		
		
		public static global::litll.core.tag.StringTag get_tag(global::litll.core.LitllString this1) {
			return this1.tag;
		}
		
		
		public static global::litll.core.LitllString _new(global::litll.core.LitllString @string) {
			global::litll.idl.std.data.idl._TypeName.TypeName_Impl_.validate(@string.data);
			return ((global::litll.core.LitllString) (@string) );
		}
		
		
		public static global::litll.core.ds.Result delitllfy(global::litll.core.LitllString @string) {
			try {
				return global::litll.core.ds.Result.Ok(global::litll.idl.std.data.idl._TypeName.TypeName_Impl_._new(@string));
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
						return global::litll.core.ds.Result.Err(global::litll.idl.delitllfy.DelitllfyErrorKind.Fatal(err));
					}
					
				}
				else {
					throw;
				}
				
			}
			
			
			return null;
		}
		
		
		public static global::litll.core.ds.Result create(string @string, global::litll.core.tag.StringTag tag) {
			try {
				return global::litll.core.ds.Result.Ok(global::litll.idl.std.data.idl._TypeName.TypeName_Impl_._new(new global::litll.core.LitllString(@string, tag)));
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
		
		
		public static void validate(string @string) {
			unchecked {
				if (( @string.Length == 0 )) {
					throw global::haxe.lang.HaxeException.wrap("Type name must not be empty.");
				}
				else if ( ! (global::litll.idl.std.data.idl._TypeName.TypeName_Impl_.headEReg.match(global::haxe.lang.StringExt.substr(@string, 0, new global::haxe.lang.Null<int>(1, true)))) ) {
					throw global::haxe.lang.HaxeException.wrap("Type name must start with uppercase alphabet.");
				}
				else if ( ! (global::litll.idl.std.data.idl._TypeName.TypeName_Impl_.bodyEReg.match(global::haxe.lang.StringExt.substr(@string, 1, default(global::haxe.lang.Null<int>)))) ) {
					throw global::haxe.lang.HaxeException.wrap("Alphabets and numbers is only allowed in type name.");
				}
				
			}
		}
		
		
		public static string toString(global::litll.core.LitllString this1) {
			return this1.data;
		}
		
		
		public static string toVariableName(global::litll.core.LitllString this1) {
			unchecked {
				global::litll.core.ds.Result result = global::litll.core.@string.IdentifierTools.toCamelCase(this1.data);
				switch (result.index) {
					case 0:
					{
						return global::haxe.lang.Runtime.toString(result.@params[0]);
					}
					
					
					case 1:
					{
						throw global::haxe.lang.HaxeException.wrap(global::haxe.lang.Runtime.toString(result.@params[0]));
					}
					
					
				}
				
				return null;
			}
		}
		
		
		public static string toProcessFunctionName(global::litll.core.LitllString this1) {
			return global::haxe.lang.Runtime.concat(global::litll.idl.std.data.idl._TypeName.TypeName_Impl_.toVariableName(this1), "Process");
		}
		
		
		public static global::litll.core.LitllString map(global::litll.core.LitllString this1, global::haxe.lang.Function func) {
			return global::litll.idl.std.data.idl._TypeName.TypeName_Impl_._new(new global::litll.core.LitllString(global::haxe.lang.Runtime.toString(func.__hx_invoke1_o(default(double), this1.data)), this1.tag));
		}
		
		
	}
}



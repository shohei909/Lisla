// Generated by Haxe 3.4.0

#pragma warning disable 109, 114, 219, 429, 168, 162
namespace litll.idl.std.data.idl {
	public class ImportDeclaration : global::haxe.lang.HxObject {
		
		public ImportDeclaration(global::haxe.lang.EmptyObject empty) {
		}
		
		
		public ImportDeclaration(global::litll.idl.std.data.idl.ModulePath module) {
			global::litll.idl.std.data.idl.ImportDeclaration.__hx_ctor_litll_idl_std_data_idl_ImportDeclaration(this, module);
		}
		
		
		public static void __hx_ctor_litll_idl_std_data_idl_ImportDeclaration(global::litll.idl.std.data.idl.ImportDeclaration __hx_this, global::litll.idl.std.data.idl.ModulePath module) {
			__hx_this.module = module;
		}
		
		
		public global::litll.idl.std.data.idl.ModulePath module;
		
		public override object __hx_setField(string field, int hash, object @value, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 1087583404:
					{
						this.module = ((global::litll.idl.std.data.idl.ModulePath) (@value) );
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
					case 1087583404:
					{
						return this.module;
					}
					
					
					default:
					{
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
		}
		
		
		public override void __hx_getFields(global::Array<object> baseArr) {
			baseArr.push("module");
			base.__hx_getFields(baseArr);
		}
		
		
	}
}



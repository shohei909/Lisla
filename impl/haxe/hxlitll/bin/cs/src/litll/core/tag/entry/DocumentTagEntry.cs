// Generated by Haxe 3.4.0

#pragma warning disable 109, 114, 219, 429, 168, 162
namespace litll.core.tag.entry {
	public class DocumentTagEntry : global::haxe.lang.HxObject {
		
		public DocumentTagEntry(global::haxe.lang.EmptyObject empty) {
		}
		
		
		public DocumentTagEntry() {
			global::litll.core.tag.entry.DocumentTagEntry.__hx_ctor_litll_core_tag_entry_DocumentTagEntry(this);
		}
		
		
		public static void __hx_ctor_litll_core_tag_entry_DocumentTagEntry(global::litll.core.tag.entry.DocumentTagEntry __hx_this) {
			__hx_this.content = "";
			__hx_this.positions = new global::Array<object>(new object[]{});
		}
		
		
		public string content;
		
		public global::Array<object> positions;
		
		public override object __hx_setField(string field, int hash, object @value, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 1347548074:
					{
						this.positions = ((global::Array<object>) (global::Array<object>.__hx_cast<object>(((global::Array) (@value) ))) );
						return @value;
					}
					
					
					case 427265337:
					{
						this.content = global::haxe.lang.Runtime.toString(@value);
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
					case 1347548074:
					{
						return this.positions;
					}
					
					
					case 427265337:
					{
						return this.content;
					}
					
					
					default:
					{
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
		}
		
		
		public override void __hx_getFields(global::Array<object> baseArr) {
			baseArr.push("positions");
			baseArr.push("content");
			base.__hx_getFields(baseArr);
		}
		
		
	}
}



// Generated by Haxe 3.4.0

#pragma warning disable 109, 114, 219, 429, 168, 162
namespace litll.idl.std.data.idl {
	public class TypeParameterDeclaration : global::haxe.lang.ParamEnum {
		
		public TypeParameterDeclaration(int index, object[] @params) : base(index, @params) {
		}
		
		
		public static readonly string[] __hx_constructs = new string[]{"TypeName", "Dependence"};
		
		public static global::litll.idl.std.data.idl.TypeParameterDeclaration TypeName(global::litll.core.LitllString typeName) {
			return new global::litll.idl.std.data.idl.TypeParameterDeclaration(0, new object[]{typeName});
		}
		
		
		public static global::litll.idl.std.data.idl.TypeParameterDeclaration Dependence(global::litll.idl.std.data.idl.TypeDependenceDeclaration declaration) {
			unchecked {
				return new global::litll.idl.std.data.idl.TypeParameterDeclaration(1, new object[]{declaration});
			}
		}
		
		
		public override string getTag() {
			return global::litll.idl.std.data.idl.TypeParameterDeclaration.__hx_constructs[this.index];
		}
		
		
	}
}



// Generated by Haxe 3.4.0

#pragma warning disable 109, 114, 219, 429, 168, 162
namespace litll.core.parse.@string {
	public class QuotedStringState : global::haxe.lang.ParamEnum {
		
		public QuotedStringState(int index, object[] @params) : base(index, @params) {
		}
		
		
		public static readonly string[] __hx_constructs = new string[]{"Indent", "Body", "CarriageReturn", "Quotes", "EscapeSequence"};
		
		public static readonly global::litll.core.parse.@string.QuotedStringState Indent = new global::litll.core.parse.@string.QuotedStringState(0, null);
		
		public static readonly global::litll.core.parse.@string.QuotedStringState Body = new global::litll.core.parse.@string.QuotedStringState(1, null);
		
		public static readonly global::litll.core.parse.@string.QuotedStringState CarriageReturn = new global::litll.core.parse.@string.QuotedStringState(2, null);
		
		public static global::litll.core.parse.@string.QuotedStringState Quotes(int length) {
			unchecked {
				return new global::litll.core.parse.@string.QuotedStringState(3, new object[]{length});
			}
		}
		
		
		public static global::litll.core.parse.@string.QuotedStringState EscapeSequence(global::litll.core.parse.@string.EscapeSequenceContext context) {
			unchecked {
				return new global::litll.core.parse.@string.QuotedStringState(4, new object[]{context});
			}
		}
		
		
		public override string getTag() {
			return global::litll.core.parse.@string.QuotedStringState.__hx_constructs[this.index];
		}
		
		
	}
}



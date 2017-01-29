// Generated by Haxe 3.4.0

#pragma warning disable 109, 114, 219, 429, 168, 162
namespace litll.core.@char {
	public class CodePointTools : global::haxe.lang.HxObject {
		
		static CodePointTools() {
			unchecked {
				global::litll.core.@char.CodePointTools.SLASH = 47;
				global::litll.core.@char.CodePointTools.SINGLE_QUOTE = 39;
				global::litll.core.@char.CodePointTools.DOUBLE_QUOTE = 34;
				global::litll.core.@char.CodePointTools.CR = 13;
				global::litll.core.@char.CodePointTools.LF = 10;
				global::litll.core.@char.CodePointTools.OPENNING_BRACKET = 91;
				global::litll.core.@char.CodePointTools.CLOSEING_BRACKET = 93;
				global::litll.core.@char.CodePointTools.OPENNING_BRACE = 123;
				global::litll.core.@char.CodePointTools.CLOSEING_BRACE = 125;
				global::litll.core.@char.CodePointTools.TAB = 9;
				global::litll.core.@char.CodePointTools.EXCLAMATION = 33;
				global::litll.core.@char.CodePointTools.SPACE = 32;
				global::litll.core.@char.CodePointTools.BACK_SLASH = 92;
			}
		}
		
		
		public CodePointTools(global::haxe.lang.EmptyObject empty) {
		}
		
		
		public CodePointTools() {
			global::litll.core.@char.CodePointTools.__hx_ctor_litll_core_char_CodePointTools(this);
		}
		
		
		public static void __hx_ctor_litll_core_char_CodePointTools(global::litll.core.@char.CodePointTools __hx_this) {
		}
		
		
		public static int SLASH;
		
		public static int SINGLE_QUOTE;
		
		public static int DOUBLE_QUOTE;
		
		public static int CR;
		
		public static int LF;
		
		public static int OPENNING_BRACKET;
		
		public static int CLOSEING_BRACKET;
		
		public static int OPENNING_BRACE;
		
		public static int CLOSEING_BRACE;
		
		public static int TAB;
		
		public static int EXCLAMATION;
		
		public static int SPACE;
		
		public static int BACK_SLASH;
		
		public static bool isWhitespace(int codePoint) {
			unchecked {
				switch (((int) (codePoint) )) {
					case 9:
					case 32:
					{
						return true;
					}
					
					
					default:
					{
						return false;
					}
					
				}
				
			}
		}
		
		
		public static bool isBlackListedWhitespace(int codePoint) {
			unchecked {
				switch (((int) (codePoint) )) {
					case 11:
					case 12:
					case 133:
					case 160:
					case 5760:
					case 8192:
					case 8193:
					case 8194:
					case 8195:
					case 8196:
					case 8197:
					case 8198:
					case 8199:
					case 8200:
					case 8201:
					case 8202:
					case 8232:
					case 8233:
					case 8239:
					case 8287:
					case 12288:
					{
						return true;
					}
					
					
					default:
					{
						return false;
					}
					
				}
				
			}
		}
		
		
	}
}



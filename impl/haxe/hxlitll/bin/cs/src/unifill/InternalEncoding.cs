// Generated by Haxe 3.4.0

#pragma warning disable 109, 114, 219, 429, 168, 162
namespace unifill {
	public class InternalEncoding : global::haxe.lang.HxObject {
		
		public InternalEncoding(global::haxe.lang.EmptyObject empty) {
		}
		
		
		public InternalEncoding() {
			global::unifill.InternalEncoding.__hx_ctor_unifill_InternalEncoding(this);
		}
		
		
		public static void __hx_ctor_unifill_InternalEncoding(global::unifill.InternalEncoding __hx_this) {
		}
		
		
		
		
		public static string get_internalEncoding() {
			return "UTF-16";
		}
		
		
		public static int codeUnitAt(string s, int index) {
			unchecked {
				string s1 = ((string) (s) );
				if (((bool) (( ((uint) (index) ) < ((string) (s1) ).Length )) )) {
					return ((int) (((string) (s1) )[index]) );
				}
				else {
					return -1;
				}
				
			}
		}
		
		
		public static int codePointAt(string s, int index) {
			return global::unifill._Utf16.Utf16_Impl_.codePointAt(((string) (s) ), index);
		}
		
		
		public static string charAt(string s, int index) {
			unchecked {
				string s1 = ((string) (s) );
				int c = ( (((bool) (( ((uint) (index) ) < ((string) (s1) ).Length )) )) ? (((int) (((string) (s1) )[index]) )) : (-1) );
				return ((string) (global::haxe.lang.StringExt.substr(((string) (s1) ), index, new global::haxe.lang.Null<int>(( ( ! ((( ( 55296 <= c ) && ( c <= 56319 ) ))) ) ? (1) : (2) ), true))) );
			}
		}
		
		
		public static int codePointCount(string s, int beginIndex, int endIndex) {
			return global::unifill._Utf16.Utf16_Impl_.codePointCount(((string) (s) ), beginIndex, endIndex);
		}
		
		
		public static int codePointWidthAt(string s, int index) {
			unchecked {
				string s1 = ((string) (s) );
				int c = ( (((bool) (( ((uint) (index) ) < ((string) (s1) ).Length )) )) ? (((int) (((string) (s1) )[index]) )) : (-1) );
				if ( ! ((( ( 55296 <= c ) && ( c <= 56319 ) ))) ) {
					return 1;
				}
				else {
					return 2;
				}
				
			}
		}
		
		
		public static int codePointWidthBefore(string s, int index) {
			unchecked {
				string s1 = ((string) (s) );
				int i = ( index - 1 );
				int c = ( (((bool) (( ((uint) (i) ) < ((string) (s1) ).Length )) )) ? (((int) (((string) (s1) )[i]) )) : (-1) );
				if ( ! ((( ( 56320 <= c ) && ( c <= 57343 ) ))) ) {
					return 1;
				}
				else {
					return 2;
				}
				
			}
		}
		
		
		public static int offsetByCodePoints(string s, int index, int codePointOffset) {
			unchecked {
				string s1 = ((string) (s) );
				if (( codePointOffset >= 0 )) {
					int index1 = index;
					int len = ((string) (s1) ).Length;
					int i = 0;
					while (( ( i < codePointOffset ) && ( index1 < len ) )) {
						int c = ( (((bool) (( ((uint) (index1) ) < ((string) (s1) ).Length )) )) ? (((int) (((string) (s1) )[index1]) )) : (-1) );
						index1 += ( ( ! ((( ( 55296 <= c ) && ( c <= 56319 ) ))) ) ? (1) : (2) );
						 ++ i;
					}
					
					return index1;
				}
				else {
					int index2 = index;
					int count = 0;
					while (( ( count <  - (codePointOffset)  ) && ( 0 < index2 ) )) {
						int i1 = ( index2 - 1 );
						int c1 = ( (((bool) (( ((uint) (i1) ) < ((string) (s1) ).Length )) )) ? (((int) (((string) (s1) )[i1]) )) : (-1) );
						index2 -= ( ( ! ((( ( 56320 <= c1 ) && ( c1 <= 57343 ) ))) ) ? (1) : (2) );
						 ++ count;
					}
					
					return index2;
				}
				
			}
		}
		
		
		public static int backwardOffsetByCodePoints(string s, int index, int codePointOffset) {
			unchecked {
				string s1 = ((string) (s) );
				int codePointOffset1 =  - (codePointOffset) ;
				if (( codePointOffset1 >= 0 )) {
					int index1 = index;
					int len = ((string) (s1) ).Length;
					int i = 0;
					while (( ( i < codePointOffset1 ) && ( index1 < len ) )) {
						int c = ( (((bool) (( ((uint) (index1) ) < ((string) (s1) ).Length )) )) ? (((int) (((string) (s1) )[index1]) )) : (-1) );
						index1 += ( ( ! ((( ( 55296 <= c ) && ( c <= 56319 ) ))) ) ? (1) : (2) );
						 ++ i;
					}
					
					return index1;
				}
				else {
					int index2 = index;
					int count = 0;
					while (( ( count <  - (codePointOffset1)  ) && ( 0 < index2 ) )) {
						int i1 = ( index2 - 1 );
						int c1 = ( (((bool) (( ((uint) (i1) ) < ((string) (s1) ).Length )) )) ? (((int) (((string) (s1) )[i1]) )) : (-1) );
						index2 -= ( ( ! ((( ( 56320 <= c1 ) && ( c1 <= 57343 ) ))) ) ? (1) : (2) );
						 ++ count;
					}
					
					return index2;
				}
				
			}
		}
		
		
		public static string fromCodePoint(int codePoint) {
			unchecked {
				return ((string) (( (( codePoint <= 65535 )) ? (((string) (new string(((char) (codePoint) ), 1)) )) : (((string) (global::haxe.lang.Runtime.concat(new string(((char) (( (( codePoint >> 10 )) + 55232 )) ), 1), new string(((char) (( ( codePoint & 1023 ) | 56320 )) ), 1))) )) )) );
			}
		}
		
		
		public static string fromCodePoints(object codePoints) {
			unchecked {
				global::StringBuf buf = ((global::StringBuf) (new global::StringBuf()) );
				{
					object c = ((object) (global::haxe.lang.Runtime.callField(codePoints, "iterator", 328878574, null)) );
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(c, "hasNext", 407283053, null))) {
						int c1 = ((int) (global::haxe.lang.Runtime.toInt(global::haxe.lang.Runtime.callField(c, "next", 1224901875, null))) );
						if (( c1 <= 65535 )) {
							((global::StringBuf) (buf) ).b.Append(((char) (c1) ));
						}
						else {
							((global::StringBuf) (buf) ).b.Append(((char) (( (( c1 >> 10 )) + 55232 )) ));
							((global::StringBuf) (buf) ).b.Append(((char) (( ( c1 & 1023 ) | 56320 )) ));
						}
						
					}
					
				}
				
				return ((string) (((global::StringBuf) (buf) ).b.ToString()) );
			}
		}
		
		
		public static void validate(string s) {
			global::unifill._Utf16.Utf16_Impl_.validate(((string) (s) ));
		}
		
		
		public static bool isValidString(string s) {
			try {
				global::unifill._Utf16.Utf16_Impl_.validate(((string) (s) ));
				return true;
			}
			catch (global::System.Exception __temp_catchallException1){
				global::haxe.lang.Exceptions.exception = __temp_catchallException1;
				object __temp_catchall2 = __temp_catchallException1;
				if (( __temp_catchall2 is global::haxe.lang.HaxeException )) {
					__temp_catchall2 = ((global::haxe.lang.HaxeException) (__temp_catchallException1) ).obj;
				}
				
				if (( __temp_catchall2 is global::unifill.InvalidCodeUnitSequence )) {
					global::unifill.InvalidCodeUnitSequence e = ((global::unifill.InvalidCodeUnitSequence) (__temp_catchall2) );
					{
						return false;
					}
					
				}
				else {
					throw;
				}
				
			}
			
			
			return default(bool);
		}
		
		
		public static void encodeWith(global::haxe.lang.Function f, int c) {
			unchecked {
				if (( c <= 65535 )) {
					f.__hx_invoke1_o(((double) (c) ), global::haxe.lang.Runtime.undefined);
				}
				else {
					f.__hx_invoke1_o(((double) (( (( c >> 10 )) + 55232 )) ), global::haxe.lang.Runtime.undefined);
					f.__hx_invoke1_o(((double) (( ( c & 1023 ) | 56320 )) ), global::haxe.lang.Runtime.undefined);
				}
				
			}
		}
		
		
	}
}



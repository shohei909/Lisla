package lisla.parse.char;
import unifill.CodePoint;

class CodePointTools
{
	public static inline var SEMICOLON:Int = 0x3B;
	public static inline var AT:Int = 0x40; 
	public static inline var SINGLE_QUOTE:Int = 0x27;
	public static inline var DOUBLE_QUOTE:Int = 0x22;
	public static inline var CR:Int = 0x0D;
	public static inline var LF:Int = 0x0A;
	public static inline var OPENNING_PAREN:Int = 0x28; // (
	public static inline var CLOSEING_PAREN:Int = 0x29; // )
	public static inline var TAB:Int = 0x09;
	public static inline var EXCLAMATION:Int = 0x21;
	public static inline var SPACE:Int = 0x20;

	public static inline function isWhitespace(codePoint:CodePoint):Bool
	{
		return switch (codePoint.toInt())
		{
			case SPACE | TAB:
				true;
				
			case _:
				false;
		}
	}
	
	public static inline function isBlackListedWhitespace(codePoint:CodePoint):Bool
	{
		return switch (codePoint.toInt())
		{
			case 0x000B | 0x000C | 0x0085 | 0x00A0 | 0x1680 | 0x2000 | 0x2001 | 0x2002 | 0x2003 | 0x2004 | 0x2005 | 0x2006 | 0x2007 | 0x2008 | 0x2009 | 0x200A | 0x2028 | 0x2029 | 0x202F | 0x205F | 0x3000 :
				true;
				
			case _:
				false;
		}
	}	
}

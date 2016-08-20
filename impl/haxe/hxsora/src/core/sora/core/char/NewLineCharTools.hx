package sora.core.char;

class NewLineCharTools
{
	public static inline function length(char:NewLineChar):Int 
	{
		return switch(char) {
			case Cr | Lf: 1;
			case CrLf: 2;
		}
	}
	
	public static inline function toString(char:NewLineChar):String
	{
		return switch(char) {
			case Cr: "\r";
			case Lf: "\n";
			case CrLf: "\r\n";
		} 
	}
}

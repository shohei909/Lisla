package lisla.core.parse.string;
import lisla.core.char.CodePointTools;
import hxext.ds.Maybe;
import lisla.core.ds.SourceRange;
import lisla.core.parse.ParseContext;
import lisla.core.parse.array.ArrayContext;
import unifill.CodePoint;
import unifill.Exception;
import unifill.Unicode;

class EscapeSequenceContext 
{
    private var top:ParseContext;
	public var state:EscapeSequenceState;
	public var startPosition:Int;
	
	public inline function new(top:ParseContext)
	{
		this.top = top;
        this.startPosition = top.position;
		state = EscapeSequenceState.Head;
	}
    
    public function process(codePoint:CodePoint, quoted:Bool):EscapeResult
	{
		var code = codePoint.toInt();
		
		return switch [code, state]
		{
			case [CodePointTools.BACK_SLASH, EscapeSequenceState.Head]:
				EscapeResult.Letter("\\");
			
			case [CodePointTools.SINGLE_QUOTE, EscapeSequenceState.Head]:
				EscapeResult.Letter("\'");
				
			case [CodePointTools.DOUBLE_QUOTE, EscapeSequenceState.Head]:
				EscapeResult.Letter("\"");
				
			case [CodePointTools.OPENNING_PAREN, EscapeSequenceState.Head]:
				EscapeResult.Interpolate;
                
			case [0x30, EscapeSequenceState.Head]:
				EscapeResult.Letter(String.fromCharCode(0));
				
			case [0x6E, EscapeSequenceState.Head]:
				EscapeResult.Letter("\n");
				
			case [0x72, EscapeSequenceState.Head]:
				EscapeResult.Letter("\r");
				
			case [0x74, EscapeSequenceState.Head]:
				EscapeResult.Letter("\t");
				
			case [0x75, EscapeSequenceState.Head]:
				state = EscapeSequenceState.UnicodeHead;
				EscapeResult.Continue;
				
			case [CodePointTools.OPENNING_BRACE, EscapeSequenceState.UnicodeHead]:
				state = EscapeSequenceState.UnicodeBody(0, 0);
				EscapeResult.Continue;
				
			case [
					0x30 | 0x31 | 0x32 | 0x33 | 0x34 | 0x35 | 0x36 | 0x37 | 0x38 | 0x39, // 0-9
					EscapeSequenceState.UnicodeBody(count, value)
				]:
				value = (value << 4) | (code - 0x30);
				state = EscapeSequenceState.UnicodeBody(count + 1, value);
				EscapeResult.Continue;
				
			case [
					0x41 | 0x42 | 0x43 | 0x44 | 0x45 | 0x46, // A-F
					EscapeSequenceState.UnicodeBody(count, value)
				]:
				value = (value << 4) | (code - 0x41 + 10);
				state = EscapeSequenceState.UnicodeBody(count + 1, value);
				EscapeResult.Continue;
				
			case [
					0x61 | 0x62 | 0x63 | 0x64 | 0x65 | 0x66, // a-f 
					EscapeSequenceState.UnicodeBody(count, value)
				]:
				value = (value << 4) | (code - 0x61 + 10);
				state = EscapeSequenceState.UnicodeBody(count + 1, value);
				EscapeResult.Continue;
				
			case [CodePointTools.CLOSEING_BRACE, EscapeSequenceState.UnicodeBody(count, value)]:
				if (count == 0 || 6 < count)
				{
					top.error(ParseErrorKind.InvalidDigitUnicodeEscape, new SourceRange(top.sourceMap, startPosition, top.position));
					EscapeResult.Letter("");
				}
				else
				{
					try 
					{
						EscapeResult.Letter(CodePoint.fromInt(value).toString());
					}
					catch (e:Exception)
					{
						top.error(ParseErrorKind.InvalidUnicode);
						EscapeResult.Letter("");
					}
				}
			
			case [_, _]:
				top.error(ParseErrorKind.InvalidEscapeSequence, new SourceRange(top.sourceMap, startPosition, top.position));
				EscapeResult.Letter("");
		}
	}
}

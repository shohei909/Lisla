package litll.core.parse.string;

enum EscapeSequenceState 
{
	Head;
	UnicodeHead;
	UnicodeBody(count:Int, value:Int);
}

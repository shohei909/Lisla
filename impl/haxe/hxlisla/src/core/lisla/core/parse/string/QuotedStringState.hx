package lisla.core.parse.string;

enum QuotedStringState
{
	Indent;
	Body;
	CarriageReturn;
	Quotes(length:Int);
	EscapeSequence(context:EscapeSequenceContext);
}
package lisla.parse.string;

enum QuotedStringState
{
	Indent;
	Body;
	CarriageReturn;
	Quotes(length:Int);
}

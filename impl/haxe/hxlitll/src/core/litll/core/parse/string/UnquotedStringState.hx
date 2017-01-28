package litll.core.parse.string;

enum UnquotedStringState
{
	Body(isSlash:Bool);
	EscapeSequence(context:EscapeSequenceContext);
}

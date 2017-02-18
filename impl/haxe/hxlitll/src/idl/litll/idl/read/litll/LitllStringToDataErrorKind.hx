package litll.idl.read.litll;
import litll.core.parse.ParseError;
import litll.idl.litll2backend.LitllToEntityError;

enum LitllStringToDataErrorKind 
{
	Parse(error:ParseError);
	Delitll(error:LitllToEntityError);
}

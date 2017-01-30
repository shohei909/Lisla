package litll.idl.read.litll;
import litll.core.parse.ParseError;
import litll.idl.delitllfy.DelitllfyError;

enum LitllStringToDataErrorKind 
{
	Parse(error:ParseError);
	Delitll(error:DelitllfyError);
}

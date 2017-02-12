package litll.idl.read.litll;
import litll.core.parse.ParseError;
import litll.idl.litllToBackend.LitllToBackendError;

enum LitllStringToDataErrorKind 
{
	Parse(error:ParseError);
	Delitll(error:LitllToBackendError);
}

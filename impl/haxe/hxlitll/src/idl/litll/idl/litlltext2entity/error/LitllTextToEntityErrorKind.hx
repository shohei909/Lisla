package litll.idl.litlltext2entity.error;
import litll.core.parse.ParseErrorEntry;
import litll.idl.litll2entity.error.LitllToEntityError;

enum LitllTextToEntityErrorKind 
{
	// Parse
    Parse(error:ParseErrorEntry);
    
    // ToEntity
	LitllToEntity(error:LitllToEntityError);	
}
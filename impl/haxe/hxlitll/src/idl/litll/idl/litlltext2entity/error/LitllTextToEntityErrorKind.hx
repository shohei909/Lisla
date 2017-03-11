package lisla.idl.lislatext2entity.error;
import lisla.core.parse.ParseErrorEntry;
import lisla.idl.lisla2entity.error.LislaToEntityError;

enum LislaTextToEntityErrorKind 
{
	// Parse
    Parse(error:ParseErrorEntry);
    
    // ToEntity
	LislaToEntity(error:LislaToEntityError);
}

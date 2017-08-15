package lisla.idl.lislatext2entity.error;
import lisla.error.core.InlineToBlockErrorWrapper;
import lisla.error.parse.AlTreeParseError;
import lisla.idl.lisla2entity.error.LislaToEntityError;

enum LislaTextToEntityErrorKind 
{
	// Parse
    Parse(error:AlTreeParseError);
    
    // ToEntity
	LislaToEntity(error:InlineToBlockErrorWrapper<LislaToEntityError>);
}

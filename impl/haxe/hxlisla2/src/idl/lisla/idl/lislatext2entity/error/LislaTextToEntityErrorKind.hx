package arraytree.idl.arraytreetext2entity.error;
import arraytree.error.core.InlineToBlockErrorWrapper;
import arraytree.error.parse.AlTreeParseError;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError;

enum ArrayTreeTextToEntityErrorKind 
{
	// Parse
    Parse(error:AlTreeParseError);
    
    // ToEntity
	ArrayTreeToEntity(error:InlineToBlockErrorWrapper<ArrayTreeToEntityError>);
}

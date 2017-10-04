package arraytree.idl.arraytreetext2entity.error;
import haxe.ds.Option;
import arraytree.data.meta.position.SourceMap;
import arraytree.error.core.BlockError;
import arraytree.error.core.BlockErrorHolder;
import arraytree.error.core.InlineToBlockErrorWrapper;
import arraytree.error.parse.AlTreeParseError;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError;

class ArrayTreeTextToEntityError implements BlockErrorHolder
{
    public var kind:ArrayTreeTextToEntityErrorKind;
    
    public function new (kind:ArrayTreeTextToEntityErrorKind)
    {
        this.kind = kind;
    }
    
    public function getBlockError():BlockError
    {
        return switch(kind)
        {
			case ArrayTreeTextToEntityErrorKind.Parse(error):
                error;
				
			case ArrayTreeTextToEntityErrorKind.ArrayTreeToEntity(error):
				error;
		}
    }
    
    public static function fromParse(error:AlTreeParseError):ArrayTreeTextToEntityError
    {
        return new ArrayTreeTextToEntityError(
            ArrayTreeTextToEntityErrorKind.Parse(error)
        );
    }
    
    public static function fromArrayTreeToEntity(
        error:ArrayTreeToEntityError,
        sourceMap:Option<SourceMap>
    ):ArrayTreeTextToEntityError
    {
        return new ArrayTreeTextToEntityError(
            ArrayTreeTextToEntityErrorKind.ArrayTreeToEntity(
                new InlineToBlockErrorWrapper(
                    error,
                    sourceMap
                )
            )
        );
    }
}

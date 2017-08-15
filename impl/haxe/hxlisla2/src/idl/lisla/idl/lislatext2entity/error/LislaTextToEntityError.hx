package lisla.idl.lislatext2entity.error;
import haxe.ds.Option;
import lisla.data.meta.position.SourceMap;
import lisla.error.core.BlockError;
import lisla.error.core.BlockErrorHolder;
import lisla.error.core.InlineToBlockErrorWrapper;
import lisla.error.parse.AlTreeParseError;
import lisla.idl.lisla2entity.error.LislaToEntityError;

class LislaTextToEntityError implements BlockErrorHolder
{
    public var kind:LislaTextToEntityErrorKind;
    
    public function new (kind:LislaTextToEntityErrorKind)
    {
        this.kind = kind;
    }
    
    public function getBlockError():BlockError
    {
        return switch(kind)
        {
			case LislaTextToEntityErrorKind.Parse(error):
                error;
				
			case LislaTextToEntityErrorKind.LislaToEntity(error):
				error;
		}
    }
    
    public static function fromParse(error:AlTreeParseError):LislaTextToEntityError
    {
        return new LislaTextToEntityError(
            LislaTextToEntityErrorKind.Parse(error)
        );
    }
    
    public static function fromLislaToEntity(
        error:LislaToEntityError,
        sourceMap:Option<SourceMap>
    ):LislaTextToEntityError
    {
        return new LislaTextToEntityError(
            LislaTextToEntityErrorKind.LislaToEntity(
                new InlineToBlockErrorWrapper(
                    error,
                    sourceMap
                )
            )
        );
    }
}

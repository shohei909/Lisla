package lisla.idl.error;

import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.data.meta.position.Position;
import lisla.data.meta.position.SourceMap;
import lisla.error.core.Error;
import lisla.error.core.IErrorDetail;
import lisla.error.core.IErrorDetailHolder;
import lisla.error.template.TemplateFinalizeError;
using hxext.ds.OptionTools;

class IdlLibraryError extends Error<IdlLibraryErrorDetail>
{
    public function new(kind:IdlLibraryErrorKind, position:Maybe<Position>) 
    {
        super(
            new IdlLibraryErrorDetail(kind),
            position
        );
    }
}

class IdlLibraryErrorDetail implements IErrorDetailHolder
{
    public var kind(default, null):IdlLibraryErrorKind;
    
    public function new (kind:IdlLibraryErrorKind)
    {
        this.kind = kind;
    }
    
    public function getDetail():IErrorDetail
    {
        return switch (kind)
        {
            case IdlLibraryErrorKind.Module(error):
                error.getDetail();
        }
    }
}

package lisla.error.parse;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.data.meta.position.Position;
import lisla.data.meta.position.SourceMap;
import lisla.error.core.Error;
import lisla.error.core.IErrorDetail;
import lisla.error.core.IErrorDetailHolder;
import lisla.error.template.TemplateFinalizeError;
using hxext.ds.OptionTools;

class ArrayTreeParseError extends Error<ArrayTreeParseErrorDetail>
{
    public function new(kind:ArrayTreeParseErrorKind, position:Maybe<Position>) 
    {
        super(
            new ArrayTreeParseErrorDetail(kind),
            position
        );
    }
    
    public static function errorFromBasic(sourceError:BasicParseError):ArrayTreeParseError
    {
        return new ArrayTreeParseError(
            ArrayTreeParseErrorKind.Basic(sourceError.detailHolder),
            sourceError.position
        );
    }
    
    public static function errorFromTemplateFinalize(sourceError:TemplateFinalizeError):ArrayTreeParseError
    {
        return new ArrayTreeParseError(
            ArrayTreeParseErrorKind.TemplateFinalize(sourceError.detailHolder),
            sourceError.position
        );
    }
}

class ArrayTreeParseErrorDetail implements IErrorDetailHolder
{
    public var kind(default, null):ArrayTreeParseErrorKind;
    
    public function new (kind:ArrayTreeParseErrorKind)
    {
        this.kind = kind;
    }
    
    public function getDetail():IErrorDetail
    {
        return switch (kind)
        {
            case ArrayTreeParseErrorKind.Basic(error):
                error.getDetail();
                
            case ArrayTreeParseErrorKind.TemplateFinalize(error):
                error.getDetail();
        }
    }
}

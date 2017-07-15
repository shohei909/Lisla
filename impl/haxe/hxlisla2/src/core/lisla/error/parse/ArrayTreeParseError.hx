package lisla.error.parse;
import lisla.error.core.ErrorName;
import lisla.error.core.LislaError;
import lisla.error.template.TemplateFinalizeError;

class ArrayTreeParseError implements LislaError
{
    public var kind(default, null):ArrayTreeParseErrorKind;
    
    public inline function new (kind:ArrayTreeParseErrorKind)
    {
        this.kind = kind;
    }
    
    public inline function unwrap():LislaError
    {
        return switch (kind)
        {
            case ArrayTreeParseErrorKind.Basic(detailKind):
                new BasicParseError(detailKind);
                
            case ArrayTreeParseErrorKind.TemplateFinalize(detailKind):
                new TemplateFinalizeError(detailKind);
        }
    }
    
    public function toString():String
    {
        return unwrap().toString();
    }
    
    public function getErrorName():ErrorName
    {
        return unwrap().getErrorName();
    }
    
    public static function fromBasic(error:BasicParseError):ArrayTreeParseError
    {
        return new ArrayTreeParseError(ArrayTreeParseErrorKind.Basic(error.kind));
    }
    
    public static function fromTemplateFinalize(error:TemplateFinalizeError):ArrayTreeParseError
    {
        return new ArrayTreeParseError(ArrayTreeParseErrorKind.TemplateFinalize(error.kind));
    }
}

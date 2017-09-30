package lisla.error.parse;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceMap;
import lisla.error.core.BlockError;
import lisla.error.core.InlineError;
import lisla.error.template.TemplateFinalizeError;

class ArrayTreeParseError implements BlockError
{
    public var kind(default, null):ArrayTreeParseErrorKind;
    public var sourceMap:Option<SourceMap>;
    
    public inline function new (kind:ArrayTreeParseErrorKind, sourceMap:Option<SourceMap>)
    {
        this.sourceMap = sourceMap;
        this.kind = kind;
    }
    
    public function getBlockError():BlockError
    {
        return this;
    }
    
    public function getInlineError():InlineError
    {
        return switch (kind)
        {
            case ArrayTreeParseErrorKind.Basic(error):
                error;
                
            case ArrayTreeParseErrorKind.TemplateFinalize(error):
                error;
        }
    } 
   
    public function getOptionSourceMap():Option<SourceMap>
    {
        return sourceMap;
    }
}

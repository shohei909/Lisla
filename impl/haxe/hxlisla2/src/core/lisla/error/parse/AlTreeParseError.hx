package lisla.error.parse;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceMap;
import lisla.error.core.BlockError;
import lisla.error.core.InlineError;
import lisla.error.template.TemplateFinalizeError;

class AlTreeParseError implements BlockError
{
    public var kind(default, null):AlTreeParseErrorKind;
    public var sourceMap:Option<SourceMap>;
    
    public inline function new (kind:AlTreeParseErrorKind, sourceMap:Option<SourceMap>)
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
            case AlTreeParseErrorKind.Basic(error):
                error;
                
            case AlTreeParseErrorKind.TemplateFinalize(error):
                error;
        }
    } 
   
    public function getOptionSourceMap():Option<SourceMap>
    {
        return sourceMap;
    }
}

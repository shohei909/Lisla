package lisla.error.template;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.error.core.ElementaryError;
import lisla.error.core.ErrorName;
import lisla.error.core.InlineError;

class TemplateFinalizeError 
    implements InlineError 
    implements ElementaryError
{
    public var kind(default, null):TemplateFinalizeErrorKind;
    public var range(default, null):Option<Range>;
    
    public inline function new (kind:TemplateFinalizeErrorKind, range:Option<Range>)
    {
        this.kind = kind;
        this.range = range;
    }
    
    public function getOptionRange():Option<Range>
    {
        return range; 
    }
    
    public function getMessage():String
    {
        return switch (kind)
        {
            case TemplateFinalizeErrorKind.UnbindedPlaceholderExists(placeholder):
                "Unbinded placeholer is remaining. Argument " + placeholder.getUnbindedArgmentNames().join(", ") + " is required.";
        }
    }
    
    public function getErrorName():ErrorName
    {
        return ErrorName.fromEnum(kind);
    }
    
    public function getInlineError():InlineError
    {
        return this;
    }
    
    public function getElementaryError():ElementaryError 
    {
        return this;
    }
}

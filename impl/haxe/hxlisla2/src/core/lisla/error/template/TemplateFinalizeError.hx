package lisla.error.template;
import lisla.error.core.ErrorName;
import lisla.error.core.LislaError;

class TemplateFinalizeError implements LislaError
{
    public var kind(default, null):TemplateFinalizeErrorKind;
    
    public inline function new (kind:TemplateFinalizeErrorKind)
    {
        this.kind = kind;
    }
    
    public function toString():String
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
}

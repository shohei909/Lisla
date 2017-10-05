package lisla.error.template;
import haxe.ds.Option;
import lisla.data.meta.position.Position;
import lisla.data.meta.position.Range;
import lisla.error.core.Error;
import lisla.error.core.ErrorName;
import lisla.error.core.IErrorDetail;

class TemplateFinalizeError extends Error<TemplateFinalizeErrorDetail>
{
    public inline function new (kind:TemplateFinalizeErrorKind, position:Position)
    {
        super(
            new TemplateFinalizeErrorDetail(kind), 
            position
        );
    }
}

class TemplateFinalizeErrorDetail implements IErrorDetail
{
    public var kind(default, null):TemplateFinalizeErrorKind;
    public inline function new (
        kind:TemplateFinalizeErrorKind
    )
    {
        this.kind = kind;
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
    
    public function getDetail():IErrorDetail
    {
        return this;
    }
}

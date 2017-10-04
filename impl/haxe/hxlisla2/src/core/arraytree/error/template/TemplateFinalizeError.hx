package arraytree.error.template;
import haxe.ds.Option;
import arraytree.data.meta.position.Position;
import arraytree.data.meta.position.Range;
import arraytree.error.core.Error;
import arraytree.error.core.ErrorName;
import arraytree.error.core.IErrorDetail;

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

package lisla.idl.std.error;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.error.core.ElementaryError;
import lisla.error.core.ErrorName;
import lisla.error.core.InlineError;
import lisla.idl.std.entity.idl.StructElementName;

class StructFieldSuffixError 
    implements InlineError
    implements ElementaryError
{
    private var kind:StructFieldSuffixErrorKind;
    private var name:StructElementName;
    
    public function new(
        name:StructElementName, 
        kind:StructFieldSuffixErrorKind
        // TODO: 
        // range:Option<Range>
    ) 
    {
        this.name = name;
        this.kind = kind;
    }
    
    public function getMessage():String
    {
        return switch (kind)
        {
            case StructFieldSuffixErrorKind.LoopedMerge(type):
                "merging " + type.getTypeReferenceName() + " is looped";
                
            case StructFieldSuffixErrorKind.InvalidMergeTarget(type):
                "merge field is not supported for " + type.getTypeReferenceName();
                
            case StructFieldSuffixErrorKind.UnsupportedDefault(kind):
                "unsupported default value kind: " + kind;
                
            case StructFieldSuffixErrorKind.InlineForLabel:
                "inline suffix(<) for label is not supported";
                
            case StructFieldSuffixErrorKind.MergeForLabel:
                "merge suffix(<<) for label is not supported";
                
            case StructFieldSuffixErrorKind.OptionalInlineForLabel:
                "optional inline suffix(<?) for label is not supported";
                
            case StructFieldSuffixErrorKind.ArrayInlineForLabel:
                "array inline suffix(<..) for label is not supported";
        }
    }
    
    public function getErrorName():ErrorName
    {
        return ErrorName.fromEnum(kind);
    }
    
    public function getOptionRange():Option<Range>
    {
        // FIXME: 
        return Option.None;
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

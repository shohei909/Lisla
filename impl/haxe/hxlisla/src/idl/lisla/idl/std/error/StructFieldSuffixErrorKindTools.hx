package lisla.idl.std.error;
using lisla.idl.std.tools.idl.TypeReferenceTools;

class StructFieldSuffixErrorKindTools 
{
    public static function toString(kind:StructFieldSuffixErrorKind):String 
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
}

package litll.idl.std.error;
import litll.idl.std.entity.idl.FollowedTypeDefinition;
import litll.idl.std.entity.idl.StructElementKind;
import litll.idl.std.entity.idl.TypeReference;

enum StructFieldSuffixErrorKind 
{
    InlineForLabel;
    MergeForLabel;
    OptionalInlineForLabel;
    ArrayInlineForLabel;
    InvalidMergeTarget(type:TypeReference);
    LoopedMerge(type:TypeReference);
    UnsupportedDefault(kind:StructElementKind);
}

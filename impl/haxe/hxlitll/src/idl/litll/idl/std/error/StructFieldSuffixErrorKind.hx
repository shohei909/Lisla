package litll.idl.std.error;
import litll.idl.std.data.idl.FollowedTypeDefinition;
import litll.idl.std.data.idl.StructElementKind;
import litll.idl.std.data.idl.TypeReference;

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

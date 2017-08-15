package lisla.idl.std.error;
import lisla.idl.std.entity.idl.FollowedTypeDefinition;
import lisla.idl.std.entity.idl.StructElementKind;
import lisla.idl.std.entity.idl.TypeReference;

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

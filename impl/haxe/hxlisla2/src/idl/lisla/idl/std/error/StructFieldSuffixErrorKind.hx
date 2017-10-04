package arraytree.idl.std.error;
import arraytree.idl.std.entity.idl.FollowedTypeDefinition;
import arraytree.idl.std.entity.idl.StructElementKind;
import arraytree.idl.std.entity.idl.TypeReference;

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

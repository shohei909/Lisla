package litll.idl.std.error;
import litll.idl.std.data.idl.FollowedTypeDefinition;
import litll.idl.std.data.idl.StructFieldKind;
import litll.idl.std.data.idl.TypeReference;

enum StructFieldSuffixErrorKind 
{
    InlineForLabel;
    MergeForLabel;
    OptionalInlineForLabel;
    ArrayInlineForLabel;
    InvelidMargeTarget(type:TypeReference);
    UnsupportedDefault(kind:StructFieldKind);
}

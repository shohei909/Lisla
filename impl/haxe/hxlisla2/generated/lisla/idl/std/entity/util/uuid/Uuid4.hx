// This file is generated by hxarraytree.
package arraytree.idl.std.entity.util.uuid;
@:forward abstract Uuid4(arraytree.data.meta.core.StringWithMetadata) to arraytree.data.meta.core.StringWithMetadata {
    public function new(value:arraytree.data.meta.core.StringWithMetadata) {
        this = value;
    }
    public static function fromString(string:String, metadata:arraytree.data.meta.core.Metadata) {
        return new arraytree.idl.std.entity.util.uuid.Uuid4(new arraytree.data.meta.core.StringWithMetadata(string, metadata));
    }
}
// This file is generated by hxarraytree.
package arraytree.idl.std.entity.xml.lixml;
@:forward abstract LixmlAttributeValue(arraytree.data.meta.core.StringWithMetadata) to arraytree.data.meta.core.StringWithMetadata {
    public function new(value:arraytree.data.meta.core.StringWithMetadata) {
        this = value;
    }
    public static function fromString(string:String, metadata:arraytree.data.meta.core.Metadata) {
        return new arraytree.idl.std.entity.xml.lixml.LixmlAttributeValue(new arraytree.data.meta.core.StringWithMetadata(string, metadata));
    }
}
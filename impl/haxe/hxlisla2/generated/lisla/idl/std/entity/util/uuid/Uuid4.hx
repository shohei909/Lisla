// This file is generated by hxlisla.
package lisla.idl.std.entity.util.uuid;
@:forward abstract Uuid4(lisla.data.meta.core.StringWithMetadata) to lisla.data.meta.core.StringWithMetadata {
    public function new(value:lisla.data.meta.core.StringWithMetadata) {
        this = value;
    }
    public static function fromString(string:String, metadata:lisla.data.meta.core.Metadata) {
        return new lisla.idl.std.entity.util.uuid.Uuid4(new lisla.data.meta.core.StringWithMetadata(string, metadata));
    }
}
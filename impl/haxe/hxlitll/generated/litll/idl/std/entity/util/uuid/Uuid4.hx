// This file is generated by hxlisla.
package lisla.idl.std.entity.util.uuid;
@:forward abstract Uuid4(lisla.core.LislaString) to lisla.core.LislaString {
    public function new(value:lisla.core.LislaString) {
        this = value;
    }
    public static function fromString(string:String, ?tag:hxext.ds.Maybe<lisla.core.tag.StringTag>) {
        return new lisla.idl.std.entity.util.uuid.Uuid4(new lisla.core.LislaString(string, tag));
    }
}
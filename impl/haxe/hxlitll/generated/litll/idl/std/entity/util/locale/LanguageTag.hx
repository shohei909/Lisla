// This file is generated by hxlisla.
package lisla.idl.std.entity.util.locale;
@:forward abstract LanguageTag(lisla.core.LislaString) to lisla.core.LislaString {
    public function new(value:lisla.core.LislaString) {
        this = value;
    }
    public static function fromString(string:String, ?tag:hxext.ds.Maybe<lisla.core.tag.StringTag>) {
        return new lisla.idl.std.entity.util.locale.LanguageTag(new lisla.core.LislaString(string, tag));
    }
}
// This file is generated by hxlitll.
package litll.idl.std.data.core;
@:forward abstract LitllDateTime(litll.core.LitllString) to litll.core.LitllString {
    public function new(value:litll.core.LitllString) {
        this = value;
    }
    public static function fromString(string:String, ?tag:hxext.ds.Maybe<litll.core.tag.StringTag>) {
        return new litll.idl.std.data.core.LitllDateTime(new litll.core.LitllString(string, tag));
    }
}
// This file is generated by hxlitll.
package litll.idl.std.data.document;
class HeaderDocument {
    public var encoding : haxe.ds.Option<litll.idl.std.data.document.DocumentEncoding>;
    public var license : Array<litll.idl.std.data.document.License>;
    public var author : Array<litll.idl.std.data.document.Author>;
    public var schema : haxe.ds.Option<litll.idl.std.data.idl.TypeReference>;
    public function new(encoding:haxe.ds.Option<litll.idl.std.data.document.DocumentEncoding>, license:Array<litll.idl.std.data.document.License>, author:Array<litll.idl.std.data.document.Author>, schema:haxe.ds.Option<litll.idl.std.data.idl.TypeReference>) {
        this.encoding = encoding;
        this.license = license;
        this.author = author;
        this.schema = schema;
    }
}
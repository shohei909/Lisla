// This file is generated by hxlitll.
package litll.idl.std.data.idl.library;
class LibraryConfig {
    public var version : haxe.ds.Option<litll.idl.std.data.util.version.Version>;
    public var extension : litll.idl.std.data.idl.library.FileExtensionTuple;
    public var lib : litll.idl.std.data.idl.library.LibraryDependenceTuple;
    public function new(version:haxe.ds.Option<litll.idl.std.data.util.version.Version>, extension:litll.idl.std.data.idl.library.FileExtensionTuple, lib:litll.idl.std.data.idl.library.LibraryDependenceTuple) {
        this.version = version;
        this.extension = extension;
        this.lib = lib;
    }
}
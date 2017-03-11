package litll.idl.generator.source;
import haxe.ds.Option;
import haxe.io.Path;
import hxext.ds.Result;
import litll.idl.generator.error.ReadIdlError;
import litll.idl.generator.source.file.IdlFilePath;
import litll.idl.std.data.idl.LocalModulePath;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.data.idl.PackagePath;
import sys.FileSystem;
import sys.io.File;

interface IdlSourceReader {
    public function moduleExists(directory:String, path:ModulePath):Bool;
    public function directoryExists(directory:String, path:PackagePath):Bool;
    public function getChildren(directory:String, path:PackagePath):Array<String>;
    public function getModule(directory:String, path:ModulePath):Option<String>;
    public function getModuleFilePath(directory:String, path:ModulePath):String;
}

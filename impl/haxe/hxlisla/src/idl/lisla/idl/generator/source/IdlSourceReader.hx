package lisla.idl.generator.source;
import haxe.ds.Option;
import haxe.io.Path;
import hxext.ds.Result;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.source.file.IdlFilePath;
import lisla.idl.std.entity.idl.LocalModulePath;
import lisla.idl.std.entity.idl.ModulePath;
import lisla.idl.std.entity.idl.PackagePath;
import sys.FileSystem;
import sys.io.File;

interface IdlSourceReader {
    public function moduleExists(directory:String, path:ModulePath):Bool;
    public function directoryExists(directory:String, path:PackagePath):Bool;
    public function getChildren(directory:String, path:PackagePath):Array<String>;
    public function getModule(directory:String, path:ModulePath):Option<String>;
    public function getModuleFilePath(directory:String, path:ModulePath):String;
}

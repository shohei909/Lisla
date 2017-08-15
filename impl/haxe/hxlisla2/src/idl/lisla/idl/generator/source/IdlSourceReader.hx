package lisla.idl.generator.source;
import haxe.ds.Option;
import lisla.idl.std.entity.idl.ModulePath;
import lisla.idl.std.entity.idl.PackagePath;
import lisla.project.FilePathFromProjectRoot;

interface IdlSourceReader 
{
    public function moduleExists(directory:FilePathFromProjectRoot, path:ModulePath):Bool;
    public function directoryExists(directory:FilePathFromProjectRoot, path:PackagePath):Bool;
    public function getChildren(directory:FilePathFromProjectRoot, path:PackagePath):Array<String>;
    public function getModule(directory:FilePathFromProjectRoot, path:ModulePath):Option<String>;
    public function getModuleFilePath(directory:FilePathFromProjectRoot, path:ModulePath):FilePathFromProjectRoot;
}

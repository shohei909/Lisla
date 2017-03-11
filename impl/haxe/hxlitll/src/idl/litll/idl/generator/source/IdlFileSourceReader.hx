package litll.idl.generator.source;
import haxe.ds.Option;
import haxe.io.Path;
import hxext.ds.Result;
import litll.idl.generator.error.ReadIdlError;
import litll.idl.generator.error.ReadIdlErrorKind;
import litll.idl.std.entity.idl.LocalModulePath;
import litll.idl.std.entity.idl.ModulePath;
import litll.idl.std.entity.idl.PackagePath;

#if sys
import sys.FileSystem;
import sys.io.File;

class IdlFileSourceReader implements IdlSourceReader
{
    public function new() {}
    
    public function moduleExists(directory:String, path:ModulePath):Bool
    {
		var filePath = getModuleFilePath(directory, path);
        return (FileSystem.exists(filePath) && !FileSystem.isDirectory(filePath));
    }
    
    public function directoryExists(directory:String, path:PackagePath):Bool
    {
		var localPath = Path.join(path.path);
        var dirPath = directory + "/" + localPath;
        return (FileSystem.exists(dirPath) && FileSystem.isDirectory(dirPath));
    }
    
    public function getChildren(directory:String, path:PackagePath):Array<String>
    {
        var localPath = Path.join(path.path);
        var dirPath = directory + "/" + localPath;
        var suffix = ".idl.litll";
        var names = [];
        
        if (FileSystem.exists(dirPath) && FileSystem.isDirectory(dirPath))
        {
            for (childName in FileSystem.readDirectory(dirPath))
            {
                if (FileSystem.isDirectory(dirPath + "/" + childName))
                {
                    names.push(childName);
                }
                else
                {
                    if (StringTools.endsWith(childName, suffix))
                    {
                        names.push(childName.substr(0, childName.length - suffix.length));
                    }
                }
            }
        }
        
        return names;
    }
    
    public function getModule(directory:String, path:ModulePath):Option<String>
    {
	    var filePath = getModuleFilePath(directory, path);
        
        return if (FileSystem.exists(filePath) && !FileSystem.isDirectory(filePath))
        {
            Option.Some(File.getContent(filePath));
        }
        else
        {
            Option.None;
        }
    }
    
    public function getModuleFilePath(directory:String, path:ModulePath):String 
    {
		var localPath = Path.join(path.path);
	    return directory + "/" + localPath + ".idl.litll";
    }
}
#end
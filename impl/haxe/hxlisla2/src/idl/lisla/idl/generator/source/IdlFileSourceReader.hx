package lisla.idl.generator.source;
import haxe.ds.Option;
import haxe.io.Path;
import hxext.ds.Result;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.error.LoadIdlErrorKind;
import lisla.idl.std.entity.idl.LocalModulePath;
import lisla.idl.std.entity.idl.ModulePath;
import lisla.idl.std.entity.idl.PackagePath;
import lisla.project.FilePathFromProjectRoot;
import lisla.project.ProjectRootDirectory;

#if sys
import sys.FileSystem;
import sys.io.File;

class IdlFileSourceReader implements IdlSourceReader
{
    public var projectRoot:ProjectRootDirectory;
    
    public function new(projectRoot:ProjectRootDirectory) 
    {
        this.projectRoot = projectRoot;
    }
    
    public function directoryExists(
        directory:FilePathFromProjectRoot, 
        path:PackagePath
    ):Bool
    {
		var localPath = Path.join(path.path);
        var dirPath = directory.concat(localPath);
        return (projectRoot.exists(dirPath) && projectRoot.isDirectory(dirPath));
    }
    
    public function getChildren(
        directory:FilePathFromProjectRoot, 
        path:PackagePath
    ):Array<FilePathFromProjectRoot>
    {
        var localPath = Path.join(path.path);
        var dirPath = directory.concat(localPath);
        var suffix = ".idl.lisla";
        var names = [];
        
        if (projectRoot.exists(dirPath) && projectRoot.isDirectory(dirPath))
        {
            for (childFileName in projectRoot.readDirectory(dirPath))
            {
                var childPath = dirPath.concat(childFileName);
                if (projectRoot.isDirectory(childPath))
                {
                    names.push(childPath);
                }
                else
                {
                    if (StringTools.endsWith(childPath, suffix))
                    {
                        names.push(childPath);
                    }
                }
            }
        }
        
        return names;
    }
    
    public function moduleExists(
        directory:FilePathFromProjectRoot, 
        path:ModulePath
    ):Bool
    {
		var filePath = getModuleFilePath(directory, path);
        return (projectRoot.exists(filePath) && !projectRoot.isDirectory(filePath));
    }
    
    public function getModule(
        directory:FilePathFromProjectRoot, 
        path:ModulePath
    ):Option<String>
    {
	    var filePath = getModuleFilePath(directory, path);
        
        return if (projectRoot.exists(filePath) && !projectRoot.isDirectory(filePath))
        {
            Option.Some(projectRoot.getContent(filePath));
        }
        else
        {
            Option.None;
        }
    }
    
    public function getModuleFilePath(
        directory:FilePathFromProjectRoot, 
        path:ModulePath
    ):FilePathFromProjectRoot
    {
		var localPath = Path.join(path.path);
	    return directory.concat(localPath + ".idl.lisla");
    }
}

#end

package lisla.project;
import lisla.project.FilePathFromProjectRoot;
import sys.FileSystem;
import sys.io.File;

class ProjectRootAndFilePath
{
    public var projectRoot(default, null):ProjectRootDirectory;
    public var filePath(default, null):FilePathFromProjectRoot;
    
    public function new(
        projectRoot:ProjectRootDirectory,
        filePath:FilePathFromProjectRoot
    )
    {
        this.projectRoot = projectRoot;
        this.filePath = filePath;
    }
    
    public function toString():String
    {
        return projectRoot.concat(filePath);
    }
}

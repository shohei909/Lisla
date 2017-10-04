package arraytree.project;
import arraytree.project.LocalPath;
import sys.FileSystem;
import sys.io.File;

class FullPath
{
    public var projectRoot(default, null):ProjectRootDirectory;
    public var localPath(default, null):LocalPath;
    
    public function new(
        projectRoot:ProjectRootDirectory,
        filePath:LocalPath
    )
    {
        this.projectRoot = projectRoot;
        this.localPath = filePath;
    }
    
    public function toString():String
    {
        return projectRoot.concat(localPath);
    }
}

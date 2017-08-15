package lisla.project;
import lisla.project.FilePathFromProjectRoot;
import sys.FileSystem;
import sys.io.File;

class Project 
{
    public var rootDirectory(default, null):ProjectRootDirectory;
    
    public function new(rootDirectory:ProjectRootDirectory) 
    {
        this.rootDirectory = rootDirectory;
    }   
    
}

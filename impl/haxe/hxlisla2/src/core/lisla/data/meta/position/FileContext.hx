package lisla.data.meta.position;
import haxe.ds.Option;
import lisla.project.LocalPath;
import lisla.project.ProjectRootDirectory;

class FileContext 
{
    public var projectRoot:Option<ProjectRootDirectory>;
    public var filePath:Option<LocalPath>;
    
    public function new() {
        
    }
    
}
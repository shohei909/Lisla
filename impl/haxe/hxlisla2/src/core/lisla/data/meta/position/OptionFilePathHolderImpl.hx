package lisla.data.meta.position;
import haxe.ds.Option;
import haxe.ds.Option;
import lisla.project.ProjectRootAndFilePath;

class OptionFilePathHolderImpl
{
    public var filePath:Option<ProjectRootAndFilePath>;
    
    public function new(filePath:Option<ProjectRootAndFilePath>) 
    {
        this.filePath = filePath;
    }
    
    public function getOptionFilePath():Option<ProjectRootAndFilePath>
    {
        return filePath;
    }
}

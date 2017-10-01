package lisla.data.meta.position;
import haxe.ds.Option;
import lisla.project.LocalPath;
import lisla.project.ProjectRootDirectory;

class Position 
{
    public var projectRoot:Option<ProjectRootDirectory>;
    public var file:Option<LocalPath>;
    public var sourceMap:Array<SourceMap>;
    public var range:Option<Range>;
    
    public function new(
        projectRoot:Option<ProjectRootDirectory>,
        file:Option<LocalPath>,
        sourceMap:Array<SourceMap>,
        range:Option<Range>
    )
    {
        this.projectRoot = projectRoot;
        this.file = file;
        this.sourceMap = sourceMap;
        this.range = range;
    }
}

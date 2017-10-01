package lisla.data.meta.position;
import lisla.data.meta.position.Position;
import lisla.data.meta.position.Range;
import lisla.project.ProjectRootDirectory;
import haxe.ds.Option;
import lisla.data.meta.position.SourceMap;
import lisla.project.LocalPath;

class SourceContext 
{
    public var projectRoot:Option<ProjectRootDirectory>;
    public var filePath:Option<LocalPath>;
    public var sourceMaps:Array<SourceMap>;

    public function new(
        projectRoot:Option<ProjectRootDirectory>,
        filePath:Option<LocalPath>,
        sourceMaps:Array<SourceMap>
    ) 
    {
        this.projectRoot = projectRoot;
        this.filePath = filePath;
        this.sourceMaps = sourceMaps;
    }
    
    public function getPosition(range:Range):Position
    {
        return new Position(
            projectRoot,
            filePath,
            sourceMaps,
            Option.Some(range)
        );
    }
}

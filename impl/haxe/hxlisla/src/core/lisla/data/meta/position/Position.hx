package lisla.data.meta.position;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.project.FullPath;
import lisla.project.LocalPath;
import lisla.project.ProjectRootDirectory;

class Position 
{
    public var projectRoot:Maybe<ProjectRootDirectory>;
    public var localPath:Maybe<LocalPath>;
    public var sourceMap:Maybe<SourceMap>;
    
    public function new(
        projectRoot:Maybe<ProjectRootDirectory>,
        localPath:Maybe<LocalPath>,
        sourceMap:Maybe<SourceMap>
    )
    {
        this.projectRoot = projectRoot;
        this.localPath = localPath;
        this.sourceMap = sourceMap;
    }

    public static function empty():Position
    {
        return new Position(
            Maybe.none(),
            Maybe.none(),
            Maybe.none()
        );
    }
    
    public function toString():String
    {
        var messages = [];
        switch [projectRoot.toOption(), localPath.toOption()]
        {
            case [Option.Some(projectRoot), Option.Some(localPath)]:
                messages.push(new FullPath(projectRoot, localPath).toString());
                
            case [Option.None, Option.Some(localPath)]:
                messages.push("project-root://" + localPath);
                
            case [Option.Some(_), Option.None] | 
                [Option.None, Option.None]:
                // nothing to do
        }

        sourceMap.iter(
            _sourceMap -> messages.push(_sourceMap.toString())
        );
        
        return if (messages.length == 0)
        {
            return "?";
        }
        else
        {
            messages.join(": ");
        }
    }
}

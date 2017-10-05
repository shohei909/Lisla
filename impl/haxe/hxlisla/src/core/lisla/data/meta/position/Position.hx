package lisla.data.meta.position;
import haxe.ds.Option;
import lisla.project.FullPath;
import lisla.project.LocalPath;
import lisla.project.ProjectRootDirectory;

class Position 
{
    public var projectRoot:Option<ProjectRootDirectory>;
    public var localPath:Option<LocalPath>;
    public var sourceMap:Option<SourceMap>;
    
    public function new(
        projectRoot:Option<ProjectRootDirectory>,
        localPath:Option<LocalPath>,
        sourceMap:Option<SourceMap>
    )
    {
        this.projectRoot = projectRoot;
        this.localPath = localPath;
        this.sourceMap = sourceMap;
    }
    
    public function toString():String
    {
        var messages = [];
        switch [projectRoot, localPath]
        {
            case [Option.Some(projectRoot), Option.Some(localPath)]:
                messages.push(new FullPath(projectRoot, localPath).toString());
                
            case [Option.None, Option.Some(localPath)]:
                messages.push("project-root://" + localPath);
                
            case [Option.Some(_), Option.None] | 
                [Option.None, Option.None]:
                // nothing to do
        }

        switch (sourceMap)
        {
            case Option.Some(_sourceMap):
                messages.push(_sourceMap.toString());
                
            case Option.None:
                // nothing to do
        }
        
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

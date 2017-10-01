package lisla.project;
import haxe.ds.Option;
import lisla.data.meta.position.SourceContext;
import lisla.parse.ParseConfig;
import lisla.parse.Parser;
import lisla.parse.result.ArrayTreeParseResult;
import lisla.project.LocalPath;
import sys.FileSystem;
import sys.io.File;

class Project 
{
    public var rootDirectory(default, null):ProjectRootDirectory;
    public var parseConfig(default, null):ParseConfig;
    
    public function new(rootDirectory:ProjectRootDirectory) 
    {
        this.rootDirectory = rootDirectory;
    }
    
    public function parse(path:LocalPath):ArrayTreeParseResult
    {
        var content = rootDirectory.getContent(path);
        var context = new SourceContext(
            Option.Some(rootDirectory),
            Option.Some(path),
            []
        );

        return Parser.parse(
            content,
            parseConfig,
            context
        );
    }
}

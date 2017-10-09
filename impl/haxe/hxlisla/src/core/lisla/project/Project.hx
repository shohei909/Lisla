package lisla.project;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.data.meta.position.Position;
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
        var position = new Position(
            Maybe.some(rootDirectory),
            Maybe.some(path),
            Maybe.none()
        );

        return Parser.parse(
            content,
            parseConfig,
            position
        );
    }
}

package arraytree.project;
import haxe.ds.Option;
import arraytree.data.meta.position.Position;
import arraytree.data.meta.position.SourceContext;
import arraytree.parse.ParseConfig;
import arraytree.parse.Parser;
import arraytree.parse.result.ArrayTreeParseResult;
import arraytree.project.LocalPath;
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
            Option.Some(rootDirectory),
            Option.Some(path),
            Option.None
        );

        return Parser.parse(
            content,
            parseConfig,
            position
        );
    }
}

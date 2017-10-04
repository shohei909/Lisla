package arraytree.project;
import haxe.ds.Option;
import arraytree.data.meta.position.Range;
import arraytree.data.meta.position.SourceMap;

class FileSourceRange
{    
    public var filePath:FullPath;
    public var sourceMap:SourceMap;
    public var range:Option<Range>;
    
    public function new(
        filePath:FullPath, 
        sourceMap:SourceMap,
        range:Option<Range>
    ) 
    {
        this.range = range;
        this.filePath = filePath;
        this.sourceMap = sourceMap;
    }
    
    public static function fromFileSourceMap(
        fileSourceMap:FileSourceMap,
        range:Option<Range>
    ):FileSourceRange
    {
        return new FileSourceRange(
            fileSourceMap.filePath,
            fileSourceMap.sourceMap,
            range
        );
    }
}

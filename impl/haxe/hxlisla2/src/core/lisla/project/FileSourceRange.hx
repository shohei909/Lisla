package lisla.project;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceMap;

class FileSourceRange
{    
    public var filePath:ProjectRootAndFilePath;
    public var sourceMap:SourceMap;
    public var range:Option<Range>;
    
    public function new(
        filePath:ProjectRootAndFilePath, 
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

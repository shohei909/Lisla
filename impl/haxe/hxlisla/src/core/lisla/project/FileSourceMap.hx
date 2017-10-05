package lisla.project;
import lisla.data.meta.position.SourceMap;

class FileSourceMap 
{    
    public var filePath:FullPath;
    public var sourceMap:SourceMap;
    
    public function new(filePath:FullPath, sourceMap:SourceMap) 
    {
        this.filePath = filePath;
        this.sourceMap = sourceMap;
    }
}
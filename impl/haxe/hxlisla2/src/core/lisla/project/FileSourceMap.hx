package lisla.project;
import lisla.data.meta.position.SourceMap;

class FileSourceMap 
{    
    public var filePath:ProjectRootAndFilePath;
    public var sourceMap:SourceMap;
    
    public function new(filePath:ProjectRootAndFilePath, sourceMap:SourceMap) 
    {
        this.filePath = filePath;
        this.sourceMap = sourceMap;
    }
}
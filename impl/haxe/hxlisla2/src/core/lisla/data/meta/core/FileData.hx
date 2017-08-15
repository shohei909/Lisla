package lisla.data.meta.core;
import lisla.data.meta.position.SourceMap;
import lisla.project.FileSourceMap;
import lisla.project.ProjectRootAndFilePath;

class FileData<T> extends BlockData<T>
{
    public var filePath(default, null):ProjectRootAndFilePath;
    
    public function new(
        data:T,
        metadata:Metadata,
        sourceMap:SourceMap,
        filePath:ProjectRootAndFilePath
    ) 
    {
        super(data, metadata, sourceMap);
        this.filePath = filePath;
    }
    
    public function getFileSourceMap():FileSourceMap
    {
        return new FileSourceMap(filePath, sourceMap);
    }
}

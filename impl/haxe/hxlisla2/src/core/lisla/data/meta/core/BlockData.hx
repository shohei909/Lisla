package lisla.data.meta.core;
import lisla.data.meta.position.SourceMap;
import lisla.project.FilePathFromProjectRoot;
import lisla.project.ProjectRootAndFilePath;

class BlockData<T>
{
    public var data(default, null):T;
    public var metadata(default, null):Metadata;
    public var sourceMap(default, null):SourceMap;
    
    public function new(
        data:T,
        metadata:Metadata,
        sourceMap:SourceMap
    ) 
    {
        this.data = data;
        this.metadata = metadata;
        this.sourceMap = sourceMap;
    }
    
    public function mapWithFilePath(filePath:ProjectRootAndFilePath):FileData<T>
    {
        return new FileData(data, metadata, sourceMap, filePath);
    }
}

package lisla.error.core;
import haxe.ds.Option;
import lisla.data.meta.position.OptionFilePathHolderImpl;
import lisla.project.ProjectRootAndFilePath;

class BlockToFileErrorWrapper<WrappedType:BlockErrorHolder> 
    extends OptionFilePathHolderImpl
    implements FileError
{
    public var error:WrappedType;
    public function new(error:WrappedType, filePath:Option<ProjectRootAndFilePath>) 
    {
        this.error = error;
        super(filePath);
    }
    
    public function getFileError():FileError
    {
        return this;
    }
    
    public function getBlockError():BlockError
    {
        return error.getBlockError();
    }
}

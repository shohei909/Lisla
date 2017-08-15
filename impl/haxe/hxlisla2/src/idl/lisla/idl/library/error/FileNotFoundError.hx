package lisla.idl.library.error;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceMap;
import lisla.error.core.BlockError;
import lisla.error.core.ElementaryError;
import lisla.error.core.ErrorName;
import lisla.error.core.FileError;
import lisla.error.core.InlineError;
import lisla.project.FilePathFromProjectRoot;
import lisla.project.ProjectRootAndFilePath;
import lisla.project.ProjectRootDirectory;

class FileNotFoundError 
    implements FileError
    implements BlockError
    implements InlineError
    implements ElementaryError
{
    public var filePath(default, null):ProjectRootAndFilePath;
    
    public function new(filePath:ProjectRootAndFilePath) 
    {
        this.filePath = filePath;
    }
    
    public function getMessage():String 
    {
        return "File is not found.";
    }
    
    public function getErrorName():ErrorName 
    {
        return ErrorName.fromClass(FileNotFoundError, "FileNotFound");
    }
    
    public function getOptionRange():Option<Range> 
    {
        return Option.None;
    }
    
    public function getOptionSourceMap():Option<SourceMap> 
    {
        return Option.None;
    }
    
    public function getOptionFilePath():Option<ProjectRootAndFilePath> 
    {
        return Option.Some(filePath);
    }
    
    public function getElementaryError():ElementaryError
    {
        return this;
    }
    
    public function getInlineError():InlineError 
    {
        return this;
    }
    
    public function getBlockError():BlockError 
    {
        return this;
    }
    
    public function getFileError():FileError
    {
        return this;
    }
    
}
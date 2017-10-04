package arraytree.idl.library.error;
import haxe.ds.Option;
import arraytree.data.meta.position.Range;
import arraytree.data.meta.position.SourceMap;
import arraytree.error.core.BlockError;
import arraytree.error.core.ElementaryError;
import arraytree.error.core.ErrorName;
import arraytree.error.core.FileError;
import arraytree.error.core.InlineError;
import arraytree.project.FilePathFromProjectRoot;
import arraytree.project.ProjectRootAndFilePath;
import arraytree.project.ProjectRootDirectory;

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
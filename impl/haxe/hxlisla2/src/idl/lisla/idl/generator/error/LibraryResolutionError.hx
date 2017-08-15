package lisla.idl.generator.error;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceMap;
import lisla.error.core.BlockError;
import lisla.error.core.ElementaryError;
import lisla.error.core.ErrorName;
import lisla.error.core.FileError;
import lisla.error.core.InlineError;
import lisla.project.FileSourceMap;
import lisla.project.FileSourceRange;
import lisla.project.ProjectRootAndFilePath;

class LibraryResolutionError 
    implements FileError
    implements BlockError
    implements InlineError
    implements ElementaryError
{
    private var kind:LibraryResolutionErrorKind;
    private var configFileSourceRange:Option<FileSourceRange>;
    
    public function new(
        kind:LibraryResolutionErrorKind, 
        configFileSourceRange:Option<FileSourceRange>
    ) 
    {
        this.kind = kind;
        this.configFileSourceRange = configFileSourceRange;
    }
    
    public function getMessage():String 
    {
        return switch (kind)
        {
            case LibraryResolutionErrorKind.Find(error):
                error.getMessage();
                
            case LibraryResolutionErrorKind.NotFoundInConfig(name):
                "Library '" + name + " is not found in library config file";
        }
    }
    
    public function getErrorName():ErrorName 
    {
        return switch (kind)
        {
            case LibraryResolutionErrorKind.Find(error):
                error.getErrorName();
                
            case LibraryResolutionErrorKind.NotFoundInConfig(_):
                ErrorName.fromEnum(kind);
        }
    }
    
    public function getOptionRange():Option<Range> 
    {
        return switch (configFileSourceRange)
        {
            case Option.Some(_configFileSourceRange):
                _configFileSourceRange.range;
                
            case Option.None:
                Option.None;
        }
    }
    
    public function getOptionSourceMap():Option<SourceMap> 
    {
        return switch (configFileSourceRange)
        {
            case Option.Some(_configFileSourceRange):
                Option.Some(_configFileSourceRange.sourceMap);
                
            case Option.None:
                Option.None;
        }
    }
    
    public function getOptionFilePath():Option<ProjectRootAndFilePath> 
    {
        return switch (configFileSourceRange)
        {
            case Option.Some(_configFileSourceRange):
                Option.Some(_configFileSourceRange.filePath);
                
            case Option.None:
                Option.None;
        }
    }
    
    public function getFileError():FileError
    {
        return this;
    }
    
    public function getBlockError():BlockError
    {
        return this;
    }
    
    public function getInlineError():InlineError 
    {
        return this;
    }
    
    public function getElementaryError():ElementaryError 
    {
        return this;
    }
}

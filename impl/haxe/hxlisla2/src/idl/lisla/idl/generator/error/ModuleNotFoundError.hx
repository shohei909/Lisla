package lisla.idl.generator.error;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceMap;
import lisla.error.core.BlockError;
import lisla.error.core.ElementaryError;
import lisla.error.core.ErrorName;
import lisla.error.core.FileError;
import lisla.error.core.InlineError;
import lisla.idl.std.entity.idl.ModulePath;
import lisla.project.FileSourceMap;
import lisla.project.FileSourceRange;
import lisla.project.ProjectRootAndFilePath;

class ModuleNotFoundError 
    implements FileError
    implements BlockError
    implements InlineError
    implements ElementaryError
{
    private var configFileSourceRange:Option<FileSourceRange>;
    public var module(default, null):ModulePath;
    
    public function new(
        module:ModulePath,
        configFileSourceRange:Option<FileSourceRange>
    ) 
    {
        this.module = module;
        this.configFileSourceRange = configFileSourceRange;
    }
    
    public function getMessage():String
    {
        return "Module " + module.toString() + " is not found";
    }

    public function getErrorName():ErrorName
    {
        return ErrorName.fromClass(ModuleNotFoundError, "ModuleNotFound");
    }
    
    public function getOptionRange():Option<Range> 
    {
        return switch (configFileSourceRange)
        {
            case Option.Some(_fileSourceRange):
                _fileSourceRange.range;
                
            case Option.None:
                Option.None;
        }
    }

    public function getOptionSourceMap():Option<SourceMap> 
    {
        return switch (configFileSourceRange)
        {
            case Option.Some(_fileSourceRange):
                Option.Some(_fileSourceRange.sourceMap);
                
            case Option.None:
                Option.None;
        }
    }
    
    public function getOptionFilePath():Option<ProjectRootAndFilePath> 
    {
        return switch (configFileSourceRange)
        {
            case Option.Some(_fileSourceRange):
                Option.Some(_fileSourceRange.filePath);
                
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

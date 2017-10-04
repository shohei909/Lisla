package arraytree.idl.generator.error;
import haxe.ds.Option;
import arraytree.data.meta.position.Range;
import arraytree.data.meta.position.SourceMap;
import arraytree.error.core.BlockError;
import arraytree.error.core.ElementaryError;
import arraytree.error.core.ErrorName;
import arraytree.error.core.FileError;
import arraytree.error.core.InlineError;
import arraytree.idl.std.entity.idl.ModulePath;
import arraytree.project.FileSourceMap;
import arraytree.project.FileSourceRange;
import arraytree.project.ProjectRootAndFilePath;

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

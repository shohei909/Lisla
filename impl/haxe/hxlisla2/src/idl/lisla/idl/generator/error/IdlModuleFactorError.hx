package arraytree.idl.generator.error;
import haxe.ds.Option;
import arraytree.data.meta.position.Range;
import arraytree.data.meta.position.SourceMap;
import arraytree.error.core.BlockError;
import arraytree.error.core.ElementaryError;
import arraytree.error.core.ErrorName;
import arraytree.error.core.FileError;
import arraytree.error.core.InlineError;
import arraytree.print.Printer;
import arraytree.project.FileSourceRange;
import arraytree.project.ProjectRootAndFilePath;

class IdlModuleFactorError 
    implements FileError
    implements BlockError
    implements InlineError
    implements ElementaryError
{
    private var kind:IdlModuleFactorErrorKind;
    private var moduleFileSourceRange:Option<FileSourceRange>;
    
    public function new(
        kind:IdlModuleFactorErrorKind, 
        moduleFileSourceRange:Option<FileSourceRange>
    ) 
    {
        this.kind = kind;
        this.moduleFileSourceRange = moduleFileSourceRange;
    }
    
    public function getMessage():String
    {   
        return switch (kind)
        {
            /*
			case IdlModuleFactorErrorKind.ModuleDuplicated(module, existingPath):
                "Module '" + module.toString() + "' is duplicated with " + existingPath.toString();
			*/
                
			case IdlModuleFactorErrorKind.Validation(error):
				error.getInlineError().getElementaryError().getMessage();
                
            case IdlModuleFactorErrorKind.TypeReferenceToEntity(error):
				error.getBlockError().getInlineError().getElementaryError().getMessage();
    
			case IdlModuleFactorErrorKind.ModuleNotFound(path):
				"Module " + path.toString() + " is not found";
                
			case IdlModuleFactorErrorKind.TypeNameDuplicated(typePath):
                "Type '" + typePath.toString() + "' is duplicated";
				
			case IdlModuleFactorErrorKind.TypeParameterNameDuplicated(name):
				"Type parameter name '" + name.toString() + "' is duplicated";
				
			case IdlModuleFactorErrorKind.InvalidPackage(expected, actual):
				"Package name '" + expected.toString() + "' is expected but '" + actual.toString() + "'";
				
			case IdlModuleFactorErrorKind.TypeNotFound(path):
				"Type " + path.toString() + " is not found";
				
            case IdlModuleFactorErrorKind.InvalidTypeDependenceDescription(alTree):
                "Invalid '" + Printer.printAlTree(alTree) + "' is loop";
        }
    }
    
    public function getErrorName():ErrorName 
    {
        return ErrorName.fromEnum(kind);
    }
    
    public function getOptionRange():Option<Range> 
    {
        return switch (moduleFileSourceRange)
        {
            case Option.Some(_moduleFileSourceRange):
                _moduleFileSourceRange.range;
                
            case Option.None:
                Option.None;
        }
    }
    
    public function getOptionSourceMap():Option<SourceMap> 
    {
        return switch (moduleFileSourceRange)
        {
            case Option.Some(_moduleFileSourceRange):
                Option.Some(_moduleFileSourceRange.sourceMap);
                
            case Option.None:
                Option.None;
        }
    }
    
    public function getOptionFilePath():Option<ProjectRootAndFilePath> 
    {
        return switch (moduleFileSourceRange)
        {
            case Option.Some(_moduleFileSourceRange):
                Option.Some(_moduleFileSourceRange.filePath);
                
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

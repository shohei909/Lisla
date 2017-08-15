package lisla.idl.generator.error;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceMap;
import lisla.error.core.BlockError;
import lisla.error.core.ElementaryError;
import lisla.error.core.ErrorName;
import lisla.error.core.FileError;
import lisla.error.core.InlineError;
import lisla.print.Printer;
import lisla.project.FileSourceRange;
import lisla.project.ProjectRootAndFilePath;

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

package arraytree.idl.library;
import haxe.ds.Option;
import hxext.error.ErrorBuffer;
import arraytree.idl.generator.error.IdlLibraryFactorError;
import arraytree.idl.generator.error.IdlLibraryFactorErrorKind;
import arraytree.idl.generator.error.IdlModuleFactorError;
import arraytree.idl.generator.error.IdlModuleFactorErrorKind;
import arraytree.idl.generator.error.LoadIdlError;
import arraytree.idl.generator.error.LoadIdlErrorKind;
import arraytree.idl.generator.source.validate.ValidType;
import arraytree.idl.arraytree2entity.ArrayTreeToEntityConfig;
import arraytree.project.FileSourceRange;

class LoadTypesContext 
{
    public var config(default, null):ArrayTreeToEntityConfig;
    public var errors:Array<LoadIdlError>;
	
    public function new() 
    {
        errors = new Array<LoadIdlError>();
        config = new ArrayTreeToEntityConfig();
    }

    public function addLibraryFactorError(kind:IdlLibraryFactorErrorKind):Void
    {
        errors.push(
            new LoadIdlError(
                LoadIdlErrorKind.LibraryFactor(
                    new IdlLibraryFactorError(kind)
                )
            )
        );
    }
    
    public function addModuleFactorError(
        kind:IdlModuleFactorErrorKind, 
        moduleFileSourceRange:Option<FileSourceRange>
    ):Void
    {
        errors.push(
            new LoadIdlError(
                LoadIdlErrorKind.ModuleFactor(
                    new IdlModuleFactorError(kind, moduleFileSourceRange)
                )
            )
        );
    }
}

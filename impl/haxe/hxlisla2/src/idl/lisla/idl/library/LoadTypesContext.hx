package lisla.idl.library;
import haxe.ds.Option;
import hxext.error.ErrorBuffer;
import lisla.idl.generator.error.IdlLibraryFactorError;
import lisla.idl.generator.error.IdlLibraryFactorErrorKind;
import lisla.idl.generator.error.IdlModuleFactorError;
import lisla.idl.generator.error.IdlModuleFactorErrorKind;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.error.LoadIdlErrorKind;
import lisla.idl.generator.source.validate.ValidType;
import lisla.idl.lisla2entity.LislaToEntityConfig;
import lisla.project.FileSourceRange;

class LoadTypesContext 
{
    public var config(default, null):LislaToEntityConfig;
    public var errors:Array<LoadIdlError>;
	
    public function new() 
    {
        errors = new Array<LoadIdlError>();
        config = new LislaToEntityConfig();
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

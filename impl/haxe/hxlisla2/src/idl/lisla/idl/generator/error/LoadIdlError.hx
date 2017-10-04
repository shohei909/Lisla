package arraytree.idl.generator.error;

import haxe.ds.Option;
import arraytree.error.core.FileError;
import arraytree.error.core.FileErrorHolder;
import arraytree.idl.arraytreetext2entity.error.ArrayTreeTextToEntityError;
import arraytree.idl.std.entity.util.file.FilePath;
import arraytree.project.FilePathFromProjectRoot;
import arraytree.project.FileSourceRange;

class LoadIdlError implements FileErrorHolder
{
    private var filePath:FilePathFromProjectRoot;
    public var kind:LoadIdlErrorKind;
    
    public function new (kind:LoadIdlErrorKind)
    {
        this.kind = kind;
    }

    
    public function getFileError():FileError
    {
        return switch (kind)
		{
            case LoadIdlErrorKind.LibraryFactor(error):
                error.getFileError();
                
			case LoadIdlErrorKind.ModuleFactor(error):
				error;
		}
    }
    
    public static function fromLibraryFactor(error:IdlLibraryFactorError):LoadIdlError
    {
        return new LoadIdlError(LoadIdlErrorKind.LibraryFactor(error));
    }
    
    public static function fromModuleFactor(error:IdlModuleFactorError):LoadIdlError
    {
        return new LoadIdlError(LoadIdlErrorKind.ModuleFactor(error));
    }
    
    public static function fromLibraryFind(
        error:LibraryFindError,
        configFileSourceRange:Option<FileSourceRange>
    ):LoadIdlError
    {
        return LoadIdlError.fromLibraryFactor(
            new IdlLibraryFactorError(
                IdlLibraryFactorErrorKind.LibraryResolution(
                    new LibraryResolutionError(
                        LibraryResolutionErrorKind.Find(error),
                        configFileSourceRange
                    )
                )
            )
        );
    }
}

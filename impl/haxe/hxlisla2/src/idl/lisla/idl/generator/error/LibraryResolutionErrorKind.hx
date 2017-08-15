package lisla.idl.generator.error;
import haxe.macro.Expr.Metadata;
import lisla.error.core.BlockError;
import lisla.error.core.FileError;
import lisla.error.core.InlineError;

enum LibraryResolutionErrorKind
{
    Find(error:LibraryFindError);
    NotFoundInConfig(name:String);
}
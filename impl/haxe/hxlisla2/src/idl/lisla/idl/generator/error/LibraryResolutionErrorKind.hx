package arraytree.idl.generator.error;
import haxe.macro.Expr.Metadata;
import arraytree.error.core.BlockError;
import arraytree.error.core.FileError;
import arraytree.error.core.InlineError;

enum LibraryResolutionErrorKind
{
    Find(error:LibraryFindError);
    NotFoundInConfig(name:String);
}
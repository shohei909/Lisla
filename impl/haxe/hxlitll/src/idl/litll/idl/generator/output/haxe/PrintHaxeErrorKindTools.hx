package litll.idl.generator.output.haxe;
import hxext.ds.Maybe;
import litll.core.error.FileErrorSummary;

class PrintHaxeErrorKindTools 
{
    public static function getSummary(kind:PrintHaxeErrorKind):FileErrorSummary<PrintHaxeErrorKind>
    {
        return switch (kind)
        {
            case PrintHaxeErrorKind.IsNotDirectory(path):
                new FileErrorSummary(
                    path,
                    Maybe.none(),
                    "'" + path + "' is not directory.",
                    kind
                );
                
            case PrintHaxeErrorKind.OutputDirectoryNotFound(path):
                new FileErrorSummary(
                    path,
                    Maybe.none(),
                    "Output directory '" + path + "' is not found.",
                    kind
                );
        }
    }
}
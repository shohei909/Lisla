package lisla.core.error;
import hxext.ds.Maybe;
import lisla.core.ds.SourceRange;

interface IFileErrorSummary extends IInlineErrorSummary
{
    public var file:String;
}

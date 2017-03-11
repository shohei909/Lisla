package litll.core.error;
import hxext.ds.Maybe;
import litll.core.ds.SourceRange;

interface IFileErrorSummary extends IInlineErrorSummary
{
    public var file:String;
}

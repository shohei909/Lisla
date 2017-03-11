package litll.core.error;
import hxext.ds.Maybe;
import litll.core.ds.SourceRange;

interface IInlineErrorSummary 
{
    public var range:Maybe<SourceRange>;
    public var message:String;
    
    public function toString():String;
}

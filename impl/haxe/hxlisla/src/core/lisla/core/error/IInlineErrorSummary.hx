package lisla.core.error;
import hxext.ds.Maybe;
import lisla.core.ds.SourceRange;

interface IInlineErrorSummary 
{
    public var range:Maybe<SourceRange>;
    public var message:String;
    
    public function toString():String;
}

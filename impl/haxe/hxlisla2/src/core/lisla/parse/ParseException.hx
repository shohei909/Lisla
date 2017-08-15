package lisla.parse;

import lisla.error.core.InlineToBlockErrorWrapper;
import lisla.error.parse.BasicParseError;

class ParseException 
{
    public var errors:Array<InlineToBlockErrorWrapper<BasicParseError>>;
    
    public function new(errors:Array<InlineToBlockErrorWrapper<BasicParseError>>) 
    {
        this.errors = errors;
    }
}

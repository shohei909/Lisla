package lisla.parse;

import lisla.error.core.Error;
import lisla.error.parse.BasicParseError;

class ParseException 
{
    public var errors:Array<BasicParseError>;
    
    public function new(errors:Array<BasicParseError>) 
    {
        this.errors = errors;
    }
}

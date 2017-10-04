package arraytree.parse;

import arraytree.error.core.Error;
import arraytree.error.parse.BasicParseError;

class ParseException 
{
    public var errors:Array<BasicParseError>;
    
    public function new(errors:Array<BasicParseError>) 
    {
        this.errors = errors;
    }
}

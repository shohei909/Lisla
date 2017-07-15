package lisla.parse;
import lisla.data.leaf.template.TemplateLeaf;
import lisla.data.meta.position.DataWithRange;
import lisla.error.parse.BasicParseError;
import lisla.parse.result.ParseErrorResult;

class ParseException 
{
    public var errorResult:ParseErrorResult<BasicParseError>;
    
    public function new(errorResult:ParseErrorResult<BasicParseError>) 
    {
        this.errorResult = errorResult;
    }
}

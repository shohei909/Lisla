package lisla.parse;

import hxext.ds.Result;
import lisla.error.parse.ArrayTreeParseError;
import lisla.parse.result.ArrayTreeParseResult;
import lisla.parse.result.ArrayTreeTemplateParseResult;
import lisla.template.TemplateFinalizer;
using unifill.Unifill;

class Parser
{
    public static function parse(string:String, ?config:ParserConfig):ArrayTreeParseResult
    {
		if (config == null) 
		{
			config = new ParserConfig();
		}
        
        var template = switch (parseTemplate(string, config))
        {
            case Result.Ok(ok):
                ok;
                
            case Result.Error(errorResult):
                return Result.Error(errorResult.map(ArrayTreeParseError.fromBasic));
        }
        
        return switch (template.mapOrError(TemplateFinalizer.finalize, config.persevering))
        {
            case Result.Ok(ok):
                Result.Ok(ok);
                
            case Result.Error(errorResult):
                Result.Error(errorResult.map(ArrayTreeParseError.fromTemplateFinalize));
        }
    }
    
	public static function parseTemplate(string:String, ?config:ParserConfig):ArrayTreeTemplateParseResult
	{
		if (config == null) 
		{
			config = new ParserConfig();
		}
		
		var parser = new ParseContext(string, config);
        
		try
		{
			for (codePoint in string.uIterator())
			{
				parser.process(codePoint);
			}
			
			return parser.end();
		}
		catch (exception:ParseException)
		{
			return Result.Error(exception.errorResult);
		}
	}
}

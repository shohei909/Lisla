package lisla.parse;

import haxe.ds.Option;
import hxext.ds.Result;
import lisla.data.tree.al.AlTreeArrayTools;
import lisla.data.tree.al.AlTreeBlock;
import lisla.error.parse.AlTreeParseError;
import lisla.error.parse.AlTreeParseErrorKind;
import lisla.parse.result.AlTreeParseResult;
import lisla.parse.result.AlTreeTemplateParseResult;
import lisla.template.TemplateFinalizer;
using unifill.Unifill;

class Parser
{
    public static function parse(string:String, ?config:ParserConfig):AlTreeParseResult
    {
		if (config == null) 
		{
			config = new ParserConfig();
		}
        
        var template = switch (parseTemplate(string, config))
        {
            case Result.Ok(ok):
                ok;
                
            case Result.Error(errors):
                return Result.Error(
                    [for (error in errors) new AlTreeParseError(AlTreeParseErrorKind.Basic(error.error), error.getOptionSourceMap())]
                );
        }
        
        return switch (AlTreeArrayTools.mapOrError(template.data, TemplateFinalizer.finalize, config.persevering))
        {
            case Result.Ok(ok):
                Result.Ok(new AlTreeBlock(ok, template.metadata, template.sourceMap));
                
            case Result.Error(errors):
                Result.Error(
                    [for (error in errors) new AlTreeParseError(AlTreeParseErrorKind.TemplateFinalize(error), Option.Some(template.sourceMap))]
                );
        }
    }
    
	public static function parseTemplate(string:String, ?config:ParserConfig):AlTreeTemplateParseResult
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
			return Result.Error(exception.errors);
		}
	}
}

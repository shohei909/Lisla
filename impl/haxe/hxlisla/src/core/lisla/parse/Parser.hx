package lisla.parse;

import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.data.meta.position.Position;
import lisla.data.tree.array.ArrayTreeArrayTools;
import lisla.data.tree.array.ArrayTreeDocument;
import lisla.error.parse.ArrayTreeParseError;
import lisla.parse.result.ArrayTreeParseResult;
import lisla.parse.result.ArrayTreeTemplateParseResult;
import lisla.template.TemplateFinalizer;
using unifill.Unifill;

class Parser
{
    public static function parse(
        string:String,
        ?config:ParseConfig,
        ?position:Position
    ):ArrayTreeParseResult
    {
		if (config == null) 
		{
			config = new ParseConfig();
		}
        if (position == null) 
		{
			position = new Position(
                Maybe.none(),
                Maybe.none(),
                Maybe.none()
            );
		}
        
        var template = switch (parseTemplate(string, config, position))
        {
            case Result.Ok(ok):
                ok;
                
            case Result.Error(errors):
                return Result.Error(
                    [for (error in errors) ArrayTreeParseError.errorFromBasic(error)]
                );
        }
        
        return switch (ArrayTreeArrayTools.mapOrError(template.data, TemplateFinalizer.finalize, config.persevering))
        {
            case Result.Ok(ok):
                Result.Ok(new ArrayTreeDocument(ok, template.tag));
                
            case Result.Error(errors):
                Result.Error(
                    [for (error in errors) ArrayTreeParseError.errorFromTemplateFinalize(error)]
                );
        }
    }
    
	public static function parseTemplate(
        string:String, 
        ?config:ParseConfig,
        ?position:Position
    ):ArrayTreeTemplateParseResult
	{
		if (config == null) 
		{
			config = new ParseConfig();
		}
        if (position == null) 
		{
			position = Position.empty();
		}

		var parser = new ParseState(
            string, 
            config, 
            position
        );

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

package lisla.parse;

import haxe.ds.Option;
import hxext.ds.Result;
import lisla.data.meta.position.CodePointIndex;
import lisla.data.meta.position.SourceContext;
import lisla.data.tree.array.ArrayTreeArrayTools;
import lisla.data.tree.array.ArrayTreeDocument;
import lisla.error.parse.ArrayTreeParseError;
import lisla.error.parse.ArrayTreeParseErrorKind;
import lisla.parse.result.ArrayTreeParseResult;
import lisla.parse.result.ArrayTreeTemplateParseResult;
import lisla.template.TemplateFinalizer;
using unifill.Unifill;

class Parser
{
    public static function parse(
        string:String,
        ?config:ParseConfig,
        ?context:SourceContext
    ):ArrayTreeParseResult
    {
		if (config == null) 
		{
			config = new ParseConfig();
		}
        if (context == null) 
		{
			context = new SourceContext(
                Option.None,
                Option.None,
                []
            );
		}
        
        var template = switch (parseTemplate(string, config, context))
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
                Result.Ok(new ArrayTreeDocument(ok, template.context, template.metadata));
                
            case Result.Error(errors):
                Result.Error(
                    [for (error in errors) ArrayTreeParseError.errorFromTemplateFinalize(error)]
                );
        }
    }
    
	public static function parseTemplate(
        string:String, 
        ?config:ParseConfig,
        ?context:SourceContext
    ):ArrayTreeTemplateParseResult
	{
		if (config == null) 
		{
			config = new ParseConfig();
		}
        if (context == null) 
		{
			context = new SourceContext(
                Option.None,
                Option.None,
                []
            );
		}

		var parser = new ParseState(
            string, 
            config, 
            context,
            new CodePointIndex(0)
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

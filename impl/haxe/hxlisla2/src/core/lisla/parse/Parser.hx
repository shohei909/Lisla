package lisla.parse;

import haxe.ds.Option;
import hxext.ds.Result;
import lisla.data.tree.array.ArrayTreeArrayTools;
import lisla.data.tree.array.ArrayTreeBlock;
import lisla.error.parse.ArrayTreeParseError;
import lisla.error.parse.ArrayTreeParseErrorKind;
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
                
            case Result.Error(errors):
                return Result.Error(
                    [for (error in errors) new ArrayTreeParseError(ArrayTreeParseErrorKind.Basic(error.error), error.getOptionSourceMap())]
                );
        }
        
        return switch (ArrayTreeArrayTools.mapOrError(template.data, TemplateFinalizer.finalize, config.persevering))
        {
            case Result.Ok(ok):
                Result.Ok(new ArrayTreeBlock(ok, template.metadata, template.sourceMap));
                
            case Result.Error(errors):
                Result.Error(
                    [for (error in errors) new ArrayTreeParseError(ArrayTreeParseErrorKind.TemplateFinalize(error), Option.Some(template.sourceMap))]
                );
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
			return Result.Error(exception.errors);
		}
	}
}

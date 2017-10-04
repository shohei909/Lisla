package arraytree.parse;

import haxe.ds.Option;
import hxext.ds.Result;
import arraytree.data.meta.position.CodePointIndex;
import arraytree.data.meta.position.Position;
import arraytree.data.meta.position.SourceContext;
import arraytree.data.tree.array.ArrayTreeArrayTools;
import arraytree.data.tree.array.ArrayTreeDocument;
import arraytree.error.parse.ArrayTreeParseError;
import arraytree.parse.result.ArrayTreeParseResult;
import arraytree.parse.result.ArrayTreeTemplateParseResult;
import arraytree.template.TemplateFinalizer;
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
                Option.None,
                Option.None,
                Option.None
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
			position = new Position(
                Option.None,
                Option.None,
                Option.None
            );
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

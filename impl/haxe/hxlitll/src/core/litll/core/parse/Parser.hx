package lisla.core.parse;

import haxe.ds.Option;
import lisla.core.LislaArray;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.core.ds.SourceMap;
import lisla.core.ds.SourceRange;
import lisla.core.parse.array.ArrayContext;
import lisla.core.parse.array.ArrayParent;
import lisla.core.parse.array.ArrayState;
import lisla.core.parse.array.ArrayState;
import lisla.core.parse.array.CommentContext;
import lisla.core.parse.string.EscapeSequenceState;
import lisla.core.parse.string.UnquotedStringContext;
import lisla.core.parse.tag.UnsettledArrayTag;
import lisla.core.parse.tag.UnsettledLeadingTag;
import lisla.core.parse.tag.UnsettledStringTag;
import lisla.core.parse.tag.UnsettledStringTag;
import lisla.core.tag.ArrayTag;
import unifill.CodePoint;
import unifill.Exception;

using unifill.Unifill;
using lisla.core.char.NewLineCharTools;
using lisla.core.char.CodePointTools;

class Parser
{
	public static function run(string:String, ?config:ParserConfig):Result<LislaArray<Lisla>, ParseError> 
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
		catch (error:ParseError)
		{
			return Result.Err(error);
		}
	}   
}

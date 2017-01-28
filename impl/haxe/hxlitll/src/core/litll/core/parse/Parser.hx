package litll.core.parse;

import haxe.ds.Option;
import litll.core.LitllArray;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.core.ds.SourceMap;
import litll.core.ds.SourceRange;
import litll.core.parse.array.ArrayContext;
import litll.core.parse.array.ArrayParent;
import litll.core.parse.array.ArrayState;
import litll.core.parse.array.ArrayState;
import litll.core.parse.array.CommentContext;
import litll.core.parse.string.EscapeSequenceState;
import litll.core.parse.string.UnquotedStringContext;
import litll.core.parse.tag.UnsettledArrayTag;
import litll.core.parse.tag.UnsettledLeadingTag;
import litll.core.parse.tag.UnsettledStringTag;
import litll.core.parse.tag.UnsettledStringTag;
import litll.core.tag.ArrayTag;
import unifill.CodePoint;
import unifill.Exception;

using unifill.Unifill;
using litll.core.char.NewLineCharTools;
using litll.core.char.CodePointTools;

class Parser
{
	public static function run(string:String, ?config:ParserConfig):Result<LitllArray<Litll>, ParseError> 
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

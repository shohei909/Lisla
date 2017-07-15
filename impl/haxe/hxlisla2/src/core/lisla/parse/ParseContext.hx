package lisla.parse;
import haxe.ds.Option;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.data.meta.position.CodePointIndex;
import lisla.data.meta.position.DataWithRange;
import lisla.data.meta.position.LineIndexes;
import lisla.data.meta.position.Range;
import lisla.data.tree.array.ArrayTreeDocument;
import lisla.error.parse.BasicParseError;
import lisla.error.parse.BasicParseErrorKind;
import lisla.parse.array.ArrayContext;
import lisla.parse.array.ArrayParent;
import lisla.parse.char.CodePointTools;
import lisla.parse.result.ArrayTreeTemplateParseResult;
import lisla.parse.result.ParseErrorResult;
import lisla.parse.tag.UnsettledLeadingTag;
import unifill.CodePoint;

class ParseContext
{
    public var config(default, null):ParserConfig;
    public var errors(default, null):Array<DataWithRange<BasicParseError>>;
    public var lines(default, null):LineIndexes;
    public var position(default, null):CodePointIndex;
    public var current:ArrayContext;
    private var cr:Bool;
    private var string:String;
    
	public inline function new(string:String, config:ParserConfig) 
	{
		this.string = string;
		this.config = config;
        
	    position = new CodePointIndex(0);
		lines = new LineIndexes();
		errors = [];
		cr = false;
        
		current = new ArrayContext(
            this,
            ArrayParent.Top,
            new UnsettledLeadingTag().toArrayTag(position)
        );
    }
    
    public function process(codePoint:CodePoint):Void
    {
		position++;
		var c = codePoint.toInt();
		if (c == CodePointTools.CR)
		{
			cr = true;
		}
		else if (c == CodePointTools.LF)
		{
			cr = false;
			lines.addLine(position);
		}
		else
		{
			if (cr)
			{
				lines.addLine(position - 1);
			}
			cr = false;
		}
        
        current.process(codePoint);
    }
    
    public inline function end():ArrayTreeTemplateParseResult
	{
		position += 1;
		
        var data = null;
		while (true)
		{
            switch (current.getData())
            {
                case Option.Some(_data):
                    data = _data;
                    break;
                    
                case Option.None:
            }
		}
        
		return if (errors.length > 0)
		{
			Result.Error(new ParseErrorResult(errors, lines, position));
		}
		else
		{
			Result.Ok(new ArrayTreeDocument(data.trees, data.metadata, lines, position));
		}
	}
    
	// =============================
	// Error
	// =============================
	public inline function error(kind:BasicParseErrorKind, ?range:Range):Void 
	{
		if (range == null)
		{
			range = Range.createWithEnd(this.position - 1, this.position);
		}
		
		var entry = new DataWithRange(new BasicParseError(kind), range);
		errors.push(entry);
		
		if (!config.persevering)
		{
			throw new ParseException(new ParseErrorResult(errors, lines, position));
		}
	}
}

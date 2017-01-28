package litll.core.parse;
import haxe.ds.Option;
import litll.core.char.CodePointTools;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.core.ds.SourceMap;
import litll.core.ds.SourceRange;
import litll.core.parse.array.ArrayParent;
import litll.core.parse.array.ArrayState;
import litll.core.parse.array.ArrayContext;
import litll.core.parse.tag.UnsettledLeadingTag;
import unifill.CodePoint;

class ParseContext
{
    public var config(default, null):ParserConfig;
    public var errors(default, null):Array<ParseErrorEntry>;
    public var sourceMap(default, null):SourceMap;
    public var position(default, null):Int;
    public var current:ArrayContext;
    private var cr:Bool;
    private var string:String;
    
	public inline function new(string:String, config:ParserConfig) 
	{
		this.string = string;
		this.config = config;
        
	    position = 0;
		errors = [];
		sourceMap = new SourceMap(0, 0, 0, 1);
		cr = false;
        
		current = new ArrayContext(
            this,
            ArrayParent.Top,
            ArrayState.Normal(true), 
            true, 
            new UnsettledLeadingTag(sourceMap).toArrayTag(0)
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
			sourceMap.addLine(position, position, sourceMap.lineNumber, 0);
		}
		else
		{
			if (cr)
			{
				sourceMap.addLine(position - 1, position - 1, sourceMap.lineNumber, 0);
			}
			cr = false;
		}
        
        current.process(codePoint);
    }
    
    public inline function end():Result<LitllArray<Litll>, ParseError> 
	{
		position += 1;
		
        var data;
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
			Result.Err(new ParseError(Maybe.some(data), errors));
		}
		else
		{
			Result.Ok(data);
		}
	}
    
	// =============================
	// Error
	// =============================
	public inline function error(kind:ParseErrorKind, ?range:SourceRange):Void 
	{
		if (range == null)
		{
			range = new SourceRange(sourceMap, this.position - 1, this.position);
		}
		
		var entry = new ParseErrorEntry(string, kind, range);
		errors.push(entry);
		
		if (!config.persevering)
		{
			throw new ParseError(Maybe.none(), errors);
		}
	}
}

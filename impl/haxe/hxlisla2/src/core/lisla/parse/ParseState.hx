package lisla.parse;
import haxe.ds.Option;
import haxe.macro.Expr.Position;
import hxext.ds.Result;
import lisla.data.meta.position.CodePointIndex;
import lisla.data.meta.position.LineIndexes;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.RangeCollection;
import lisla.data.meta.position.SourceContext;
import lisla.data.meta.position.SourceMap;
import lisla.data.tree.array.ArrayTreeDocument;
import lisla.error.core.Error;
import lisla.error.parse.BasicParseError;
import lisla.error.parse.BasicParseErrorKind;
import lisla.parse.array.ArrayContext;
import lisla.parse.array.ArrayParent;
import lisla.parse.char.CodePointTools;
import lisla.parse.metadata.UnsettledLeadingTag;
import lisla.parse.result.ArrayTreeTemplateParseResult;
import unifill.CodePoint;

class ParseState
{
    public var context(default, null):SourceContext;
    public var sourceMap(default, null):SourceMap;
    public var config(default, null):ParseConfig;
    public var errors(default, null):Array<BasicParseError>;
    public var position(default, null):CodePointIndex;
    public var current:ArrayContext;
    private var cr:Bool;
    private var string:String;
    private var currentRange:Range;
    
	public inline function new(
        string:String, 
        config:ParseConfig, 
        context:SourceContext,
        startPosition:CodePointIndex
    ) 
	{
        this.string = string;
		this.config = config;
        this.sourceMap = new SourceMap(
            new RangeCollection([]),
            new LineIndexes()
        );
		this.context = new SourceContext(
            context.projectRoot,
            context.filePath,
            context.sourceMaps.concat([sourceMap])
        );
        
	    position = new CodePointIndex(0);
		errors = [];
		cr = false;
        
		current = new ArrayContext(
            this,
            ArrayParent.Top,
            new UnsettledLeadingTag().toArrayTag(position)
        );
        
        startRange(startPosition);
    }
    
    public function startRange(codePointIndex:CodePointIndex):Void
    {
        currentRange = Range.createWithLength(codePointIndex, 0);
        sourceMap.ranges.ranges.push(currentRange);
    }
    
    public function process(codePoint:CodePoint):Void
    {
        currentRange.length++;
		position++;
		var c = codePoint.toInt();
		if (c == CodePointTools.CR)
		{
			cr = true;
		}
		else if (c == CodePointTools.LF)
		{
			cr = false;
			sourceMap.lines.addLine(position);
		}
		else
		{
			if (cr)
			{
				sourceMap.lines.addLine(position - 1);
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
			Result.Error(errors);
		}
		else
		{
			Result.Ok(new ArrayTreeDocument(data.trees, context, data.metadata));
		}
	}
    
	// =============================
	// Error
	// =============================
    
	public inline function error(kind:BasicParseErrorKind, range:Range):Void 
    {
        var position = context.getPosition(range);
    	var error = new BasicParseError(kind, position);
		errors.push(error);
		
		if (!config.persevering)
		{
			throw new ParseException(errors);
		}
	}
    
    public inline function errorWithCurrentPosition(kind:BasicParseErrorKind):Void 
    {
        var range = Range.createWithEnd(this.position - 1, this.position);
		return error(kind, range);
    }
}

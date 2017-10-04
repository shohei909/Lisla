package arraytree.parse;
import haxe.ds.Option;
import hxext.ds.Result;
import arraytree.data.meta.position.CodePointIndex;
import arraytree.data.meta.position.LineIndexes;
import arraytree.data.meta.position.Position;
import arraytree.data.meta.position.Range;
import arraytree.data.meta.position.RangeCollection;
import arraytree.data.meta.position.SourceContext;
import arraytree.data.meta.position.SourceMap;
import arraytree.data.tree.array.ArrayTreeDocument;
import arraytree.error.core.Error;
import arraytree.error.parse.BasicParseError;
import arraytree.error.parse.BasicParseErrorKind;
import arraytree.parse.array.ArrayContext;
import arraytree.parse.array.ArrayParent;
import arraytree.parse.char.CodePointTools;
import arraytree.parse.tag.UnsettledLeadingTag;
import arraytree.parse.result.ArrayTreeTemplateParseResult;
import unifill.CodePoint;

class ParseState
{
    public var context(default, null):SourceContext;
    public var config(default, null):ParseConfig;
    public var errors(default, null):Array<BasicParseError>;
    public var codePointIndex(default, null):CodePointIndex;
    public var current:ArrayContext;
    private var cr:Bool;
    private var string:String;
    
	public inline function new(
        string:String, 
        config:ParseConfig, 
        position:Position
    ) 
	{
        this.string = string;
		this.config = config;
		this.context = new SourceContext(position);
	    this.codePointIndex = new CodePointIndex(0);
		errors = [];
		cr = false;
        
		current = new ArrayContext(
            this,
            ArrayParent.Top,
            new UnsettledLeadingTag().toArrayTag(true, codePointIndex)
        );
        
    }
    
    
    public function process(codePoint:CodePoint):Void
    {
		codePointIndex++;
		var c = codePoint.toInt();
		if (c == CodePointTools.CR)
		{
			cr = true;
		}
		else if (c == CodePointTools.LF)
		{
			cr = false;
			context.lines.addLine(codePointIndex);
		}
		else
		{
			if (cr)
			{
				context.lines.addLine(codePointIndex - 1);
			}
			cr = false;
		}
        
        current.process(codePoint);
    }
    
    public inline function end():ArrayTreeTemplateParseResult
	{
		codePointIndex += 1;
		
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
			Result.Ok(new ArrayTreeDocument(data.trees, data.tag));
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
        var range = Range.createWithEnd(this.codePointIndex - 1, this.codePointIndex);
		return error(kind, range);
    }
}

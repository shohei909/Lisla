package format.sora.tag;
import unifill.CodePoint;
import format.sora.parser.ParserConfig;
import haxe.ds.Option;

class Tag
{
	public var document:Option<DocumentTag>;
	public var format:Option<FormatTag>;
	public var position:Option<Range>;
	
	public function new() 
	{
		
	}
	
	public inline function writeDocument(config:ParserConfig, codePoint:CodePoint, position:Int) 
	{
		if (config.outputsDocument) 
		{
			var doc = switch (document) 
			{
				case Option.Some(doc):
					doc;
				
				case Option.None:
					var doc = new DocumentTag();
					document = Option.Some(doc);
					doc;
			}
			
			doc.content += codePoint.toString();
			
			var l = doc.positions.length;
			if (l == 0 || doc.positions[l - 1].right + 1 != position)
			{
				doc.positions.push(new Range(position, position + 1));
			}
			else
			{
				doc.positions[l - 1].right += 1;
			}
		}
	}
}

package lisla.parse.result;
import lisla.data.meta.position.CodePointIndex;
import lisla.data.meta.position.LineIndexes;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.RangeCollection;
import lisla.data.meta.position.SourceMap;

class ParseResultBase 
{
    public var lines(default, null):LineIndexes;
    public var length(default, null):CodePointIndex;

    public function new(
        lines:LineIndexes,
        length:CodePointIndex
    ) 
    {
        this.lines = lines;
        this.length = length;
    }
    
    public function getSourceMap():SourceMap
    {
        return new SourceMap(
            new RangeCollection(
                [Range.createWithLength(new CodePointIndex(0), new CodePointIndex(length))]
            ),
            lines
        );
    }
}

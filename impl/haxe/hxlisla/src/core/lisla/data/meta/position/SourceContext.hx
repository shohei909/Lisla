package lisla.data.meta.position;
import hxext.ds.Maybe;
import lisla.data.meta.position.Position;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceMap;

class SourceContext 
{
    public var position(default, null):Position;
    public var lines:LineIndexes;
    
    public function new(position:Position) 
    {
        this.position = position;
        lines = new LineIndexes();
    }
    
    public function getPosition(range:Range):Position
    {
        return getPositionWithRanges([range]);
    }
    
    public function getPositionWithRanges(ranges:Array<Range>):Position
    {
        return new Position(
            position.projectRoot,
            position.localPath,
            Maybe.some(
                position.sourceMap.match(
                    _sourceMap -> _sourceMap.mergeRanges(ranges),
                    () -> new SourceMap(lines, new RangeCollection(ranges))
                )
            )
        );
    }
}

package lisla.data.meta.position;
import lisla.data.meta.position.Position;
import lisla.data.meta.position.Range;
import lisla.project.ProjectRootDirectory;
import haxe.ds.Option;
import lisla.data.meta.position.SourceMap;
import lisla.project.LocalPath;

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
            Option.Some(
                switch (position.sourceMap)
                {
                    case Option.Some(_sourceMap):
                        _sourceMap.mergeRanges(ranges);
                        
                    case Option.None:
                        new SourceMap(lines, new RangeCollection(ranges));
                }
            )
        );
    }
}

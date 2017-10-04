package arraytree.data.meta.position;
import arraytree.data.meta.position.Position;
import arraytree.data.meta.position.Range;
import arraytree.project.ProjectRootDirectory;
import haxe.ds.Option;
import arraytree.data.meta.position.SourceMap;
import arraytree.project.LocalPath;

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

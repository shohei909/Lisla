package lisla.data.meta.core;
import haxe.ds.Option;
import lisla.data.meta.comment.DocumentComment;
import lisla.data.meta.position.Position;
import lisla.data.meta.position.Range;

class Metadata 
{
    public var position:Position;
    public var documentComment:Option<DocumentComment>;
    
    public function new(position:Position) 
    {
        this.position = position;
        documentComment = Option.None;
    }
    
    public function shallowClone():Metadata
    {
        var metadata = new Metadata(position);
        metadata.documentComment = documentComment;
        return metadata;
    }
}

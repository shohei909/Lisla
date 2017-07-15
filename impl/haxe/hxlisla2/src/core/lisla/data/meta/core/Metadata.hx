package lisla.data.meta.core;
import haxe.ds.Option;
import lisla.data.meta.comment.DocumentComment;
import lisla.data.meta.position.Range;

class Metadata 
{
    public var range:Option<Range>;
    public var documentComment:Option<DocumentComment>;
    
    public function new() 
    {
        range = Option.None;
        documentComment = Option.None;
    }
    
    public function shallowClone():Metadata
    {
        var metadata = new Metadata();
        metadata.range = range;
        metadata.documentComment = documentComment;
        return metadata;
    }
}

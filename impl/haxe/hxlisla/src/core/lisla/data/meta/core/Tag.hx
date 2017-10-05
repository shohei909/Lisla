package lisla.data.meta.core;
import haxe.ds.Option;
import lisla.data.meta.comment.DocumentComment;
import lisla.data.meta.position.Position;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceContext;

class Tag {
    public var position:Position;
    public var innerPosition:Position;
    public var documentComment:Option<DocumentComment>;

    public function new(
        position:Position,
        innerPosition:Position
    ) {
        this.innerPosition = innerPosition;
        this.position = position;
        documentComment = Option.None;
    }

    public function shallowClone():Tag {
        var tag = new Tag(position, innerPosition);
        tag.documentComment = documentComment;
        return tag;
    }
}

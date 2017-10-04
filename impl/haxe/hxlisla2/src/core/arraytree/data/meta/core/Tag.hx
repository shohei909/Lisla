package arraytree.data.meta.core;
import haxe.ds.Option;
import arraytree.data.meta.comment.DocumentComment;
import arraytree.data.meta.position.Position;
import arraytree.data.meta.position.Range;
import arraytree.data.meta.position.SourceContext;

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

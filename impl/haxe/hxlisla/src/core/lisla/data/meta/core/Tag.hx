package lisla.data.meta.core;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.data.meta.comment.DocumentComment;
import lisla.data.meta.position.Position;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceContext;

class Tag 
{
    public var position:Position;
    public var innerPosition:Position;
    public var documentComment:Maybe<DocumentComment>;

    public function new(
        position:Position,
        innerPosition:Position
    ) {
        this.innerPosition = innerPosition;
        this.position = position;
        documentComment = Maybe.none();
    }

    public function shallowClone():Tag {
        var tag = new Tag(position, innerPosition);
        tag.documentComment = documentComment;
        return tag;
    }
}

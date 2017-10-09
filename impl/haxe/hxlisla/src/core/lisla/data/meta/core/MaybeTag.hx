package lisla.data.meta.core;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.data.meta.comment.DocumentComment;
import lisla.data.meta.position.Position;

@:forward
abstract MaybeTag(Maybe<Tag>) from Maybe<Tag>
{
    public var position(get, never):Position;
    private function get_position():Position {
        return this.match(
            (t) -> t.position,
            () -> Position.empty()
        );
    }
    public var innerPosition(get, never):Position;
    private function get_innerPosition():Position {
        return this.match(
            (t) -> t.innerPosition,
            () -> Position.empty()
        );
    }
    public var documentComment(get, never):Maybe<DocumentComment>; 
    private function get_documentComment():Maybe<DocumentComment> 
    {
        return this.flatMap(t -> t.documentComment);
    }

    public function shallowClone():MaybeTag
    {
        return this.map(t -> t.shallowClone());
    }
}

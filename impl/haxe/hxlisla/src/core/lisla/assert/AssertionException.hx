package lisla.assert;
import haxe.PosInfos;
import hxext.ds.Maybe;
import lisla.data.meta.position.Position;
import lisla.error.exception.FatalException;

class AssertionException extends FatalException
{
    public function new(message:String, position:Maybe<Position>, posInfos:PosInfos) 
    {
        super(message, "AssertionError", position, posInfos);
    }
}
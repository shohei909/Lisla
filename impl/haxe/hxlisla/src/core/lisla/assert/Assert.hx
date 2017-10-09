package lisla.assert;
import haxe.PosInfos;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Printer;
import hxext.ds.Maybe;
import lisla.assert.AssertionException;
import lisla.data.meta.position.Position;
import lisla.parse.string.QuotedStringLine;

class Assert 
{
    public static macro function assert(expr:Expr, ?position:Expr):Expr
    {
        var pos = Context.currentPos();
        var printer = new Printer();
        var string = printer.printExpr(expr);
        return macro @:pos(pos) lisla.assert.InternalAssert.assert($v{string}, $expr, $position);
    }
}

class InternalAssert
{
    public static inline function assert(text:String, value:Bool, ?position:Maybe<Position>, ?posInfos:PosInfos):Void
    {
        if (!value)
        {
            throw new AssertionException(text + " : should be true", position, posInfos);
        }
    }
}

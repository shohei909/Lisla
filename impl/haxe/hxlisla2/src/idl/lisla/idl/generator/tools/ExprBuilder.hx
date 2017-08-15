package lisla.idl.generator.tools;
import haxe.macro.Expr;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.data.tree.al.AlTree;
import lisla.data.meta.core.ArrayWithMetadata;
import lisla.data.meta.core.StringWithMetadata;
import lisla.data.meta.core.Metadata;
import lisla.data.tree.al.AlTreeKind;

class ExprBuilder 
{
    public static function createGetOrReturnExpr(expr:Expr):Expr
    {
        return macro switch ($expr)
        {
            case hxext.ds.Result.Ok(data): data;
            case hxext.ds.Result.Error(data): return hxext.ds.Result.Error(data);
        }
    }
    
    public static function createSwitchExpr(targetExpr:Expr, cases:Array<Case>):Expr
    {
        return {
            expr: ExprDef.ESwitch(
                targetExpr,
                cases,
                null
            ),
            pos: null
        };
    }
    
    public static function createAndExpr(exprs:Array<Expr>):Expr 
    {
        return if (exprs.length == 0)
        {
            macro true;
        }
        else if (exprs.length == 1)
        {
            exprs[0];
        }
        else
        {
            expr: ExprDef.EBinop(Binop.OpBoolAnd, exprs[0], createAndExpr(exprs.slice(1))),
            pos: null
        };
    }
    
    public static function getStringConstExpr(label:String):Expr
    {
        return {
            expr: ExprDef.EConst(Constant.CString(label)),
            pos: null,
        };
    }
    
    public static function getIntConstExpr(value:Int) {
        return {
            expr: ExprDef.EConst(Constant.CInt(Std.string(value))),
            pos: null,
        };
    }
    
    public static function getStringArrayExpr(values:Array<String>):Expr
    {
        var exprs = [for (v in values) getStringConstExpr(v)];
        return macro [$a{exprs}];
    }
    
    public static function lislaExpr(lisla:AlTree<String>):Expr
    {
        return switch lisla.kind
        {
            case AlTreeKind.Arr(arr):
                var arrExpr = [for (child in arr.data) lislaExpr(child)];
                macro lisla.data.tree.al.AlTreeKind.Arr(
                    new lisla.data.meta.core.ArrayWithMetadata([$a{arrExpr}])
                );
                
            case AlTreeKind.Leaf(str):
                var strExpr = getStringConstExpr(str.data);
                macro lisla.data.tree.al.AlTreeKind.Leaf(
                    new lisla.data.meta.core.StringWithMetadata($strExpr)
                );
        }
    }
}

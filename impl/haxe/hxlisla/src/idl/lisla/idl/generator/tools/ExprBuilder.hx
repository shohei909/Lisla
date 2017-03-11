package lisla.idl.generator.tools;
import haxe.macro.Expr;
import hxext.ds.Result;

class ExprBuilder 
{
    public static function createGetOrReturnExpr(expr:Expr):Expr
    {
        return macro switch ($expr)
        {
            case hxext.ds.Result.Ok(data): data;
            case hxext.ds.Result.Err(data): return hxext.ds.Result.Err(data);
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
}
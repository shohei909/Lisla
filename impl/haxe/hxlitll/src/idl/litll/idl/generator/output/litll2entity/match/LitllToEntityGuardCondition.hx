package litll.idl.generator.output.litll2entity.match;
import haxe.ds.Option;
import haxe.macro.Expr;
import litll.core.Litll;
import litll.idl.generator.output.litll2entity.match.LitllToEntityGuardConditionKind;
using litll.idl.std.tools.idl.TypeReferenceTools;

class LitllToEntityGuardCondition
{
    public var min(default, null):Int = 0;
    public var max(default, null):Option<Int>;
    public var conditions(default, null):Array<LitllToEntityGuardConditionKind>;
    
    public function new (min:Int, max:Option<Int>, conditions:Array<LitllToEntityGuardConditionKind>)
    {
        this.min = min;
        this.max = max;
        this.conditions = conditions;
    }
    
    public static function any():LitllToEntityGuardCondition
    {
        return new LitllToEntityGuardCondition(0, Option.None, []);
    }
    
    public function getConditionExprs(dataExpr:Expr):Array<Expr>
    {
        var result = [];
        var minValue = {
            expr: ExprDef.EConst(Constant.CInt(Std.string(min))),
            pos: null,
        }
        
        switch (max)
        {
            case Option.Some(max) if (max == min):
                result.push(macro $dataExpr.length == $minValue);
                
            case Option.Some(max):
                var maxValue = {
                    expr: ExprDef.EConst(Constant.CInt(Std.string(max))),
                    pos: null,
                }
                result.push(macro $minValue <= $dataExpr.length);
                result.push(macro $dataExpr.length <= $maxValue);
                
            case Option.None:
                if (0 < min)
                {
                    result.push(macro $minValue <= $dataExpr.length);
                }
        }
        
        
        for (i in 0...conditions.length)
        {
            var condition = conditions[i];
            var index = {
                expr: ExprDef.EConst(Constant.CInt(Std.string(i))),
                pos: null,
            }
            inline function addConst(strings:Map<String, Bool>):Void
            {
                for (key in strings.keys())
                {
                    var string = {
                        expr: ExprDef.EConst(Constant.CString(key)),
                        pos: null,
                    }
                    result.push(macro $dataExpr.data[$index].match(litll.core.Litll.Str(_.data => $string)));
                }
            }
            
            switch (condition)
            {
                case LitllToEntityGuardConditionKind.Const(strings):
                    addConst(strings);
                    
                case LitllToEntityGuardConditionKind.Str:
                    result.push(macro $dataExpr.data[$index].match(litll.core.Litll.Str(_)));
                    
                case LitllToEntityGuardConditionKind.Arr:
                    result.push(macro $dataExpr.data[$index].match(litll.core.Litll.Arr(_)));
                    
                case LitllToEntityGuardConditionKind.ArrOrConst(strings):
                    addConst(strings);
                    result.push(macro $dataExpr.data[$index].match(litll.core.Litll.Arr(_)));
                    
                case LitllToEntityGuardConditionKind.Never:
                    result.push(macro false);
                    
                case LitllToEntityGuardConditionKind.Always:
            }
        }
        
        return result;
    }
    
    public function isSolid():Bool
    {
        return switch (max)
        {
            case Option.Some(value) if (value == min):
                true;
                
            case _:
                false;
        }
    }
    
    public function getFixedLength():Option<Int>
    {
        return if (isSolid())
        {
            Option.Some(min);
        }
        else
        {
            Option.None;
        }
    }
}
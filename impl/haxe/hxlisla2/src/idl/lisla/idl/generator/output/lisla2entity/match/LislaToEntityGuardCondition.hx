package lisla.idl.generator.output.lisla2entity.match;
import haxe.ds.Option;
import haxe.macro.Expr;
import lisla.data.tree.al.AlTree;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityGuardConditionKind;
using lisla.idl.std.tools.idl.TypeReferenceTools;

class LislaToEntityGuardCondition
{
    public var min(default, null):Int = 0;
    public var max(default, null):Option<Int>;
    public var conditions(default, null):Array<LislaToEntityGuardConditionKind>;
    
    public function new (min:Int, max:Option<Int>, conditions:Array<LislaToEntityGuardConditionKind>)
    {
        this.min = min;
        this.max = max;
        this.conditions = conditions;
    }
    
    public static function any():LislaToEntityGuardCondition
    {
        return new LislaToEntityGuardCondition(0, Option.None, []);
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
                    result.push(macro $dataExpr.data[$index].match(lisla.data.tree.al.AlTreeKind.Leaf(_ => $string)));
                }
            }
            
            switch (condition)
            {
                case LislaToEntityGuardConditionKind.Const(strings):
                    addConst(strings);
                    
                case LislaToEntityGuardConditionKind.Str:
                    result.push(macro $dataExpr.data[$index].match(lisla.data.tree.al.AlTreeKind.Leaf(_)));
                    
                case LislaToEntityGuardConditionKind.Arr:
                    result.push(macro $dataExpr.data[$index].match(lisla.data.tree.al.AlTreeKind.Arr(_)));
                    
                case LislaToEntityGuardConditionKind.ArrOrConst(strings):
                    addConst(strings);
                    result.push(macro $dataExpr.data[$index].match(lisla.data.tree.al.AlTreeKind.Arr(_)));
                    
                case LislaToEntityGuardConditionKind.Never:
                    result.push(macro false);
                    
                case LislaToEntityGuardConditionKind.Always:
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

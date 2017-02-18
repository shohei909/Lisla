package litll.idl.generator.output.delitll.match;
import haxe.ds.Option;
import haxe.macro.Expr.Case;
import litll.core.LitllString;
import litll.idl.exception.IdlException;
import litll.idl.generator.output.delitll.match.LitllToEntityCaseCondition;
import litll.idl.generator.output.delitll.match.LitllToEntityGuardCondition;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.generator.source.IdlSourceReader;
import litll.idl.generator.source.validate.InlinabilityOnTuple;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.EnumConstructorKind;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.data.idl.StructFieldKind;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.FollowedTypeDefinition;
import litll.idl.std.data.idl.TypeName;
using litll.idl.std.tools.idl.TypeReferenceTools;

class LitllToEntityCaseConditionTools 
{
    public static function intersects(condition0:LitllToEntityCaseCondition, condition1:LitllToEntityCaseCondition):Bool
    {
        return switch [condition0, condition1]
        {
            case [LitllToEntityCaseCondition.Const(_), LitllToEntityCaseCondition.Str]
                | [LitllToEntityCaseCondition.Str, LitllToEntityCaseCondition.Const(_)]
                | [LitllToEntityCaseCondition.Str, LitllToEntityCaseCondition.Str]:
                true;
                
            case [LitllToEntityCaseCondition.Const(const0), LitllToEntityCaseCondition.Const(const1)]:
                const0 == const1;
                
            case [LitllToEntityCaseCondition.Arr(_), LitllToEntityCaseCondition.Const(_)]
                | [LitllToEntityCaseCondition.Arr(_), LitllToEntityCaseCondition.Str]
                | [LitllToEntityCaseCondition.Const(_), LitllToEntityCaseCondition.Arr(_)]
                | [LitllToEntityCaseCondition.Str, LitllToEntityCaseCondition.Arr(_)]:
                false;
                
            case [LitllToEntityCaseCondition.Arr(arr0), LitllToEntityCaseCondition.Arr(arr1)]:
                var shared = switch [arr0.max, arr1.max]
                {
                    case [Option.None, Option.None]:
                        true;
                        
                    case [Option.Some(max), Option.None]:
                        arr1.min <= max;
                        
                    case [Option.None, Option.Some(max)]:
                        arr0.min <= max;
                        
                    case [Option.Some(max0), Option.Some(max1)]:
                        !(arr0.min < max1 || arr1.min < max0);
                }
                
                if (shared)
                {
                    var intersects = true;
                    var length = arr0.conditions.length;
                    if (length > arr1.conditions.length)
                    {
                        length = arr1.conditions.length;
                    }
                    for (i in 0...length)
                    {
                        if (!LitllToEntityGuardConditionKindTools.intersects(arr0.conditions[i], arr1.conditions[i]))
                        {
                            intersects = false;
                            break;
                        }
                    }
                    
                    intersects;
                }
                else 
                {
                    false;
                }
        }
    }
    
    public static function getInlinability(conditions:Array<LitllToEntityCaseCondition>):InlinabilityOnTuple
    {
        return getInlinabilityWithNext(conditions, LitllToEntityGuardConditionKind.Never);
    }
    
    public static function getInlinabilityWithNext(conditions:Array<LitllToEntityCaseCondition>, nextGuard:LitllToEntityGuardConditionKind):InlinabilityOnTuple
    {
        var canFixed = true;
        var canVariable = true;
        var length = conditions.length;
        
        for (i in 0...length)
        {
            if (!canFixed) break;
            var condition0 = conditions[i];
            if (!canInlineFixed(condition0))
            {
                canFixed = false;
                break;
            }
            
            for (j in (i + 1)...length)
            {
                if (!canVariable) break;
                switch (intersectsShallow(condition0, conditions[j], nextGuard))
                {
                    case Option.None:
                        canFixed = false;
                        break;
                        
                    case Option.Some(false):
                        canVariable = false;
                        
                    case Option.Some(true):
                }
            }
        }
        
        return if (canFixed)
        {
            if (canVariable) InlinabilityOnTuple.Always else InlinabilityOnTuple.FixedLength;
        }
        else 
        {
            InlinabilityOnTuple.Never;
        }
    }
    
    public static function canInlineFixed(condition:LitllToEntityCaseCondition):Bool
    {
        return switch (condition)
        {
            case LitllToEntityCaseCondition.Const(_) | LitllToEntityCaseCondition.Str:
                false;
                
            case LitllToEntityCaseCondition.Arr(_):
                true;
        }
    }
    
    public static function intersectsShallow(condition0:LitllToEntityCaseCondition, condition1:LitllToEntityCaseCondition, nextGuard:LitllToEntityGuardConditionKind):Option<Bool>
    {
        return switch [condition0, condition1]
        {
            case [LitllToEntityCaseCondition.Const(_), _]
                | [LitllToEntityCaseCondition.Str, _]
                | [_, LitllToEntityCaseCondition.Str]
                | [_, LitllToEntityCaseCondition.Const(_)]:
                Option.None;
                
            case [LitllToEntityCaseCondition.Arr(arr0), LitllToEntityCaseCondition.Arr(arr1)]:
                inline function get(guard:LitllToEntityGuardCondition):LitllToEntityGuardConditionKind
                {
                    return switch (guard.max)
                    {
                        case Option.Some(0):
                           nextGuard; 
                            
                        case _:
                            if (guard.conditions.length > 0) 
                            {
                                var result = guard.conditions[0];
                                if (guard.min == 0) LitllToEntityGuardConditionKindTools.merge(result, nextGuard) else result;
                            }
                            else
                            {
                                LitllToEntityGuardConditionKind.Always;
                            }
                    }
                }
                
                var guard0 = get(arr0);
                var guard1 = get(arr1);
                Option.Some(LitllToEntityGuardConditionKindTools.intersects(guard0, guard1));
        }
    }
}

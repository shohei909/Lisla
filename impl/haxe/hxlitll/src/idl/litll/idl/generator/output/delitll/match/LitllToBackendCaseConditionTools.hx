package litll.idl.generator.output.delitll.match;
import haxe.ds.Option;
import haxe.macro.Expr.Case;
import litll.core.LitllString;
import litll.idl.exception.IdlException;
import litll.idl.generator.output.delitll.match.LitllToBackendCaseCondition;
import litll.idl.generator.output.delitll.match.LitllToBackendGuardCondition;
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

class LitllToBackendCaseConditionTools 
{
    public static function intersects(condition0:LitllToBackendCaseCondition, condition1:LitllToBackendCaseCondition):Bool
    {
        return switch [condition0, condition1]
        {
            case [LitllToBackendCaseCondition.Const(_), LitllToBackendCaseCondition.Str]
                | [LitllToBackendCaseCondition.Str, LitllToBackendCaseCondition.Const(_)]
                | [LitllToBackendCaseCondition.Str, LitllToBackendCaseCondition.Str]:
                true;
                
            case [LitllToBackendCaseCondition.Const(const0), LitllToBackendCaseCondition.Const(const1)]:
                const0 == const1;
                
            case [LitllToBackendCaseCondition.Arr(_), LitllToBackendCaseCondition.Const(_)]
                | [LitllToBackendCaseCondition.Arr(_), LitllToBackendCaseCondition.Str]
                | [LitllToBackendCaseCondition.Const(_), LitllToBackendCaseCondition.Arr(_)]
                | [LitllToBackendCaseCondition.Str, LitllToBackendCaseCondition.Arr(_)]:
                false;
                
            case [LitllToBackendCaseCondition.Arr(arr0), LitllToBackendCaseCondition.Arr(arr1)]:
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
                        if (!LitllToBackendGuardConditionKindTools.intersects(arr0.conditions[i], arr1.conditions[i]))
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
    
    public static function getInlinability(conditions:Array<LitllToBackendCaseCondition>):InlinabilityOnTuple
    {
        return getInlinabilityWithNext(conditions, LitllToBackendGuardConditionKind.Never);
    }
    
    public static function getInlinabilityWithNext(conditions:Array<LitllToBackendCaseCondition>, nextGuard:LitllToBackendGuardConditionKind):InlinabilityOnTuple
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
    
    public static function canInlineFixed(condition:LitllToBackendCaseCondition):Bool
    {
        return switch (condition)
        {
            case LitllToBackendCaseCondition.Const(_) | LitllToBackendCaseCondition.Str:
                false;
                
            case LitllToBackendCaseCondition.Arr(_):
                true;
        }
    }
    
    public static function intersectsShallow(condition0:LitllToBackendCaseCondition, condition1:LitllToBackendCaseCondition, nextGuard:LitllToBackendGuardConditionKind):Option<Bool>
    {
        return switch [condition0, condition1]
        {
            case [LitllToBackendCaseCondition.Const(_), _]
                | [LitllToBackendCaseCondition.Str, _]
                | [_, LitllToBackendCaseCondition.Str]
                | [_, LitllToBackendCaseCondition.Const(_)]:
                Option.None;
                
            case [LitllToBackendCaseCondition.Arr(arr0), LitllToBackendCaseCondition.Arr(arr1)]:
                inline function get(guard:LitllToBackendGuardCondition):LitllToBackendGuardConditionKind
                {
                    return switch (guard.max)
                    {
                        case Option.Some(0):
                           nextGuard; 
                            
                        case _:
                            if (guard.conditions.length > 0) 
                            {
                                var result = guard.conditions[0];
                                if (guard.min == 0) LitllToBackendGuardConditionKindTools.merge(result, nextGuard) else result;
                            }
                            else
                            {
                                LitllToBackendGuardConditionKind.Always;
                            }
                    }
                }
                
                var guard0 = get(arr0);
                var guard1 = get(arr1);
                Option.Some(LitllToBackendGuardConditionKindTools.intersects(guard0, guard1));
        }
    }
}

package litll.idl.generator.output.delitll.match;
import haxe.ds.Option;
import haxe.macro.Expr.Case;
import litll.core.LitllString;
import litll.idl.exception.IdlException;
import litll.idl.generator.output.delitll.match.DelitllfyCaseCondition;
import litll.idl.generator.output.delitll.match.DelitllfyGuardCondition;
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

class DelitllfyCaseConditionTools 
{
    public static function intersects(condition0:DelitllfyCaseCondition, condition1:DelitllfyCaseCondition):Bool
    {
        return switch [condition0, condition1]
        {
            case [DelitllfyCaseCondition.Const(_), DelitllfyCaseCondition.Str]
                | [DelitllfyCaseCondition.Str, DelitllfyCaseCondition.Const(_)]
                | [DelitllfyCaseCondition.Str, DelitllfyCaseCondition.Str]:
                true;
                
            case [DelitllfyCaseCondition.Const(const0), DelitllfyCaseCondition.Const(const1)]:
                const0 == const1;
                
            case [DelitllfyCaseCondition.Arr(_), DelitllfyCaseCondition.Const(_)]
                | [DelitllfyCaseCondition.Arr(_), DelitllfyCaseCondition.Str]
                | [DelitllfyCaseCondition.Const(_), DelitllfyCaseCondition.Arr(_)]
                | [DelitllfyCaseCondition.Str, DelitllfyCaseCondition.Arr(_)]:
                false;
                
            case [DelitllfyCaseCondition.Arr(arr0), DelitllfyCaseCondition.Arr(arr1)]:
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
                        if (!DelitllfyGuardConditionKindTools.intersects(arr0.conditions[i], arr1.conditions[i]))
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
    
    public static function getInlinability(conditions:Array<DelitllfyCaseCondition>):InlinabilityOnTuple
    {
        return getInlinabilityWithNext(conditions, DelitllfyGuardConditionKind.Never);
    }
    
    public static function getInlinabilityWithNext(conditions:Array<DelitllfyCaseCondition>, nextGuard:DelitllfyGuardConditionKind):InlinabilityOnTuple
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
    
    public static function canInlineFixed(condition:DelitllfyCaseCondition):Bool
    {
        return switch (condition)
        {
            case DelitllfyCaseCondition.Const(_) | DelitllfyCaseCondition.Str:
                false;
                
            case DelitllfyCaseCondition.Arr(_):
                true;
        }
    }
    
    public static function intersectsShallow(condition0:DelitllfyCaseCondition, condition1:DelitllfyCaseCondition, nextGuard:DelitllfyGuardConditionKind):Option<Bool>
    {
        return switch [condition0, condition1]
        {
            case [DelitllfyCaseCondition.Const(_), _]
                | [DelitllfyCaseCondition.Str, _]
                | [_, DelitllfyCaseCondition.Str]
                | [_, DelitllfyCaseCondition.Const(_)]:
                Option.None;
                
            case [DelitllfyCaseCondition.Arr(arr0), DelitllfyCaseCondition.Arr(arr1)]:
                inline function get(guard:DelitllfyGuardCondition):DelitllfyGuardConditionKind
                {
                    return switch (guard.max)
                    {
                        case Option.Some(0):
                           nextGuard; 
                            
                        case _:
                            if (guard.conditions.length > 0) 
                            {
                                var result = guard.conditions[0];
                                if (guard.min == 0) DelitllfyGuardConditionKindTools.merge(result, nextGuard) else result;
                            }
                            else
                            {
                                DelitllfyGuardConditionKind.Always;
                            }
                    }
                }
                
                var guard0 = get(arr0);
                var guard1 = get(arr1);
                Option.Some(DelitllfyGuardConditionKindTools.intersects(guard0, guard1));
        }
    }
}

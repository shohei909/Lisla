package lisla.idl.generator.output.lisla2entity.match;
import haxe.ds.Option;
import haxe.macro.Expr.Case;
import lisla.core.LislaString;
import lisla.idl.exception.IdlException;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityCaseCondition;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityGuardCondition;
import lisla.idl.generator.source.IdlSourceProvider;
import lisla.idl.generator.source.IdlSourceReader;
import lisla.idl.generator.source.validate.InlinabilityOnTuple;
import lisla.idl.std.entity.idl.Argument;
import lisla.idl.std.entity.idl.ArgumentName;
import lisla.idl.std.entity.idl.EnumConstructor;
import lisla.idl.std.entity.idl.EnumConstructorKind;
import lisla.idl.std.entity.idl.StructElement;
import lisla.idl.std.entity.idl.StructElementKind;
import lisla.idl.std.entity.idl.TupleElement;
import lisla.idl.std.entity.idl.FollowedTypeDefinition;
import lisla.idl.std.entity.idl.TypeName;
using lisla.idl.std.tools.idl.TypeReferenceTools;

class LislaToEntityCaseConditionTools 
{
    public static function intersects(condition0:LislaToEntityCaseCondition, condition1:LislaToEntityCaseCondition):Bool
    {
        return switch [condition0, condition1]
        {
            case [LislaToEntityCaseCondition.Const(_), LislaToEntityCaseCondition.Str]
                | [LislaToEntityCaseCondition.Str, LislaToEntityCaseCondition.Const(_)]
                | [LislaToEntityCaseCondition.Str, LislaToEntityCaseCondition.Str]:
                true;
                
            case [LislaToEntityCaseCondition.Const(const0), LislaToEntityCaseCondition.Const(const1)]:
                const0 == const1;
                
            case [LislaToEntityCaseCondition.Arr(_), LislaToEntityCaseCondition.Const(_)]
                | [LislaToEntityCaseCondition.Arr(_), LislaToEntityCaseCondition.Str]
                | [LislaToEntityCaseCondition.Const(_), LislaToEntityCaseCondition.Arr(_)]
                | [LislaToEntityCaseCondition.Str, LislaToEntityCaseCondition.Arr(_)]:
                false;
                
            case [LislaToEntityCaseCondition.Arr(arr0), LislaToEntityCaseCondition.Arr(arr1)]:
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
                        if (!LislaToEntityGuardConditionKindTools.intersects(arr0.conditions[i], arr1.conditions[i]))
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
    
    public static function getInlinability(conditions:Array<LislaToEntityCaseCondition>):InlinabilityOnTuple
    {
        return getInlinabilityWithNext(conditions, LislaToEntityGuardConditionKind.Never);
    }
    
    public static function getInlinabilityWithNext(conditions:Array<LislaToEntityCaseCondition>, nextGuard:LislaToEntityGuardConditionKind):InlinabilityOnTuple
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
    
    public static function canInlineFixed(condition:LislaToEntityCaseCondition):Bool
    {
        return switch (condition)
        {
            case LislaToEntityCaseCondition.Const(_) | LislaToEntityCaseCondition.Str:
                false;
                
            case LislaToEntityCaseCondition.Arr(_):
                true;
        }
    }
    
    public static function intersectsShallow(condition0:LislaToEntityCaseCondition, condition1:LislaToEntityCaseCondition, nextGuard:LislaToEntityGuardConditionKind):Option<Bool>
    {
        return switch [condition0, condition1]
        {
            case [LislaToEntityCaseCondition.Const(_), _]
                | [LislaToEntityCaseCondition.Str, _]
                | [_, LislaToEntityCaseCondition.Str]
                | [_, LislaToEntityCaseCondition.Const(_)]:
                Option.None;
                
            case [LislaToEntityCaseCondition.Arr(arr0), LislaToEntityCaseCondition.Arr(arr1)]:
                inline function get(guard:LislaToEntityGuardCondition):LislaToEntityGuardConditionKind
                {
                    return switch (guard.max)
                    {
                        case Option.Some(0):
                           nextGuard; 
                            
                        case _:
                            if (guard.conditions.length > 0) 
                            {
                                var result = guard.conditions[0];
                                if (guard.min == 0) LislaToEntityGuardConditionKindTools.merge(result, nextGuard) else result;
                            }
                            else
                            {
                                LislaToEntityGuardConditionKind.Always;
                            }
                    }
                }
                
                var guard0 = get(arr0);
                var guard1 = get(arr1);
                Option.Some(LislaToEntityGuardConditionKindTools.intersects(guard0, guard1));
        }
    }
}

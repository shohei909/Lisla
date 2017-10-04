package arraytree.idl.generator.output.arraytree2entity.match;
import haxe.ds.Option;
import haxe.macro.Expr.Case;
import arraytree.data.meta.core.StringWithMetadata;
import arraytree.idl.exception.IdlException;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityCaseCondition;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityGuardCondition;
import arraytree.idl.generator.source.IdlSourceProvider;
import arraytree.idl.generator.source.IdlSourceReader;
import arraytree.idl.generator.source.validate.InlinabilityOnTuple;
import arraytree.idl.std.entity.idl.Argument;
import arraytree.idl.std.entity.idl.ArgumentName;
import arraytree.idl.std.entity.idl.EnumConstructor;
import arraytree.idl.std.entity.idl.EnumConstructorKind;
import arraytree.idl.std.entity.idl.StructElement;
import arraytree.idl.std.entity.idl.StructElementKind;
import arraytree.idl.std.entity.idl.TupleElement;
import arraytree.idl.std.entity.idl.FollowedTypeDefinition;
import arraytree.idl.std.entity.idl.TypeName;
using arraytree.idl.std.tools.idl.TypeReferenceTools;

class ArrayTreeToEntityCaseConditionTools 
{
    public static function intersects(condition0:ArrayTreeToEntityCaseCondition, condition1:ArrayTreeToEntityCaseCondition):Bool
    {
        return switch [condition0, condition1]
        {
            case [ArrayTreeToEntityCaseCondition.Const(_), ArrayTreeToEntityCaseCondition.Str]
                | [ArrayTreeToEntityCaseCondition.Str, ArrayTreeToEntityCaseCondition.Const(_)]
                | [ArrayTreeToEntityCaseCondition.Str, ArrayTreeToEntityCaseCondition.Str]:
                true;
                
            case [ArrayTreeToEntityCaseCondition.Const(const0), ArrayTreeToEntityCaseCondition.Const(const1)]:
                const0 == const1;
                
            case [ArrayTreeToEntityCaseCondition.Arr(_), ArrayTreeToEntityCaseCondition.Const(_)]
                | [ArrayTreeToEntityCaseCondition.Arr(_), ArrayTreeToEntityCaseCondition.Str]
                | [ArrayTreeToEntityCaseCondition.Const(_), ArrayTreeToEntityCaseCondition.Arr(_)]
                | [ArrayTreeToEntityCaseCondition.Str, ArrayTreeToEntityCaseCondition.Arr(_)]:
                false;
                
            case [ArrayTreeToEntityCaseCondition.Arr(arr0), ArrayTreeToEntityCaseCondition.Arr(arr1)]:
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
                        if (!ArrayTreeToEntityGuardConditionKindTools.intersects(arr0.conditions[i], arr1.conditions[i]))
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
    
    public static function getInlinability(conditions:Array<ArrayTreeToEntityCaseCondition>):InlinabilityOnTuple
    {
        return getInlinabilityWithNext(conditions, ArrayTreeToEntityGuardConditionKind.Never);
    }
    
    public static function getInlinabilityWithNext(conditions:Array<ArrayTreeToEntityCaseCondition>, nextGuard:ArrayTreeToEntityGuardConditionKind):InlinabilityOnTuple
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
    
    public static function canInlineFixed(condition:ArrayTreeToEntityCaseCondition):Bool
    {
        return switch (condition)
        {
            case ArrayTreeToEntityCaseCondition.Const(_) | ArrayTreeToEntityCaseCondition.Str:
                false;
                
            case ArrayTreeToEntityCaseCondition.Arr(_):
                true;
        }
    }
    
    public static function intersectsShallow(condition0:ArrayTreeToEntityCaseCondition, condition1:ArrayTreeToEntityCaseCondition, nextGuard:ArrayTreeToEntityGuardConditionKind):Option<Bool>
    {
        return switch [condition0, condition1]
        {
            case [ArrayTreeToEntityCaseCondition.Const(_), _]
                | [ArrayTreeToEntityCaseCondition.Str, _]
                | [_, ArrayTreeToEntityCaseCondition.Str]
                | [_, ArrayTreeToEntityCaseCondition.Const(_)]:
                Option.None;
                
            case [ArrayTreeToEntityCaseCondition.Arr(arr0), ArrayTreeToEntityCaseCondition.Arr(arr1)]:
                inline function get(guard:ArrayTreeToEntityGuardCondition):ArrayTreeToEntityGuardConditionKind
                {
                    return switch (guard.max)
                    {
                        case Option.Some(0):
                           nextGuard; 
                            
                        case _:
                            if (guard.conditions.length > 0) 
                            {
                                var result = guard.conditions[0];
                                if (guard.min == 0) ArrayTreeToEntityGuardConditionKindTools.merge(result, nextGuard) else result;
                            }
                            else
                            {
                                ArrayTreeToEntityGuardConditionKind.Always;
                            }
                    }
                }
                
                var guard0 = get(arr0);
                var guard1 = get(arr1);
                Option.Some(ArrayTreeToEntityGuardConditionKindTools.intersects(guard0, guard1));
        }
    }
}

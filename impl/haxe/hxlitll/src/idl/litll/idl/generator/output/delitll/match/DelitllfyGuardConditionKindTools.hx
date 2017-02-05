package litll.idl.generator.output.delitll.match;

class DelitllfyGuardConditionKindTools 
{
    public static function merge(kind1:DelitllfyGuardConditionKind, kind2:DelitllfyGuardConditionKind):DelitllfyGuardConditionKind
    {
        return switch [kind1, kind2]
        {
            case [Always, _]
                | [_, Always]:
                Always;
                
            case [Never, kind]
                | [kind, Never]:
                kind;
                   
            case [Str, Str]
                | [Const(_), Str]
                | [Str, Const(_)]:
                Str;
                
            case [Arr, Arr]:
                Arr;
                
            case [Const(strings1), Const(strings2)]:
                Const(mergeStringSet(strings1, strings2));
                
            case [ArrOrConst(strings1), ArrOrConst(strings2)]
                | [Const(strings1), ArrOrConst(strings2)]
                | [ArrOrConst(strings1), Const(strings2)]:
                ArrOrConst(mergeStringSet(strings1, strings2));
                
            case [ArrOrConst(strings1), Arr]
                | [Arr, ArrOrConst(strings1)]
                | [Const(strings1), Arr]
                | [Arr, Const(strings1)]:
                ArrOrConst(strings1);
                
            case [Str, Arr]
                | [Arr, Str]
                | [Str, ArrOrConst(_)]
                | [ArrOrConst(_), Str]:
                Always;
        }
    }
    
    private static function mergeStringSet(strings1:Map<String, Bool>, strings2:Map<String, Bool>):Map<String, Bool>
    {
        var result = new Map();
        for (key in strings1.keys())
        {
            result[key] = true;
        }
        for (key in strings2.keys())
        {
            result[key] = true;
        }
        return result;
    }
}

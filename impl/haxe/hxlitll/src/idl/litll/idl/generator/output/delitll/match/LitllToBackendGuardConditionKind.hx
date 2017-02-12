package litll.idl.generator.output.delitll.match;

enum LitllToBackendGuardConditionKind
{
    Never;
    Const(strings:Map<String, Bool>);
    Str;
    Arr;
    ArrOrConst(strings:Map<String, Bool>);
    Always;
}

package litll.idl.generator.output.litll2entity.match;

enum LitllToEntityGuardConditionKind
{
    Never;
    Const(strings:Map<String, Bool>);
    Str;
    Arr;
    ArrOrConst(strings:Map<String, Bool>);
    Always;
}

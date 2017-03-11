package lisla.idl.generator.output.lisla2entity.match;

enum LislaToEntityGuardConditionKind
{
    Never;
    Const(strings:Map<String, Bool>);
    Str;
    Arr;
    ArrOrConst(strings:Map<String, Bool>);
    Always;
}

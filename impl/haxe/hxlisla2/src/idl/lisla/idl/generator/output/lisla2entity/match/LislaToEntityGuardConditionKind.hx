package arraytree.idl.generator.output.arraytree2entity.match;

enum ArrayTreeToEntityGuardConditionKind
{
    Never;
    Const(strings:Map<String, Bool>);
    Str;
    Arr;
    ArrOrConst(strings:Map<String, Bool>);
    Always;
}

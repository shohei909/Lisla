package arraytree.idl.generator.output.arraytree2entity.match;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityGuardCondition;

enum ArrayTreeToEntityCaseCondition 
{ 
    Const(string:String);
    Str;
    Arr(guard:ArrayTreeToEntityGuardCondition);
}

package litll.idl.generator.output.litll2entity.match;
import litll.idl.generator.output.litll2entity.match.LitllToEntityGuardCondition;

enum LitllToEntityCaseCondition 
{ 
    Const(string:String);
    Str;
    Arr(guard:LitllToEntityGuardCondition);
}

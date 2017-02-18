package litll.idl.generator.output.delitll.match;
import litll.idl.generator.output.delitll.match.LitllToEntityGuardCondition;

enum LitllToEntityCaseCondition 
{ 
    Const(string:String);
    Str;
    Arr(guard:LitllToEntityGuardCondition);
}

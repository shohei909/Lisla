package litll.idl.generator.output.delitll.match;
import litll.idl.generator.output.delitll.match.LitllToBackendGuardCondition;

enum LitllToBackendCaseCondition 
{ 
    Const(string:String);
    Str;
    Arr(guard:LitllToBackendGuardCondition);
}

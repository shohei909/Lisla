package litll.idl.generator.output.delitll.match;
import litll.idl.generator.output.delitll.match.DelitllfyGuardCondition;

enum DelitllfyCaseCondition 
{ 
    Const(string:String);
    Str;
    Arr(guard:DelitllfyGuardCondition);
}

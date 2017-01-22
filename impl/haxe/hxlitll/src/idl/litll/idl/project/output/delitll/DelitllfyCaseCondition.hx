package litll.idl.project.output.delitll;

enum DelitllfyCaseCondition 
{ 
    Const(string:String);
    Str;
    Arr(guard:DelitllfyGuardCondition);
}

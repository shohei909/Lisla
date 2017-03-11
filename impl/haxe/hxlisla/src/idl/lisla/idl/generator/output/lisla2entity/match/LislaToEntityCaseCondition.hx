package lisla.idl.generator.output.lisla2entity.match;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityGuardCondition;

enum LislaToEntityCaseCondition 
{ 
    Const(string:String);
    Str;
    Arr(guard:LislaToEntityGuardCondition);
}

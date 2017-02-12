package litll.idl.generator.output.delitll.match;

class FirstElementCondition 
{
    public var canBeEmpty:Bool;
    public var conditions(default, null):Array<LitllToBackendCaseCondition>;
    
    public function new(canBeEmpty:Bool, conditions:Array<LitllToBackendCaseCondition>) 
    {
        this.canBeEmpty = canBeEmpty;
        this.conditions = conditions;
    }
    
    public function addConditions(newConditions:Array<LitllToBackendCaseCondition>):Void
    {
        for (condition in newConditions)
        {
            conditions.push(condition);
        }
    }
}

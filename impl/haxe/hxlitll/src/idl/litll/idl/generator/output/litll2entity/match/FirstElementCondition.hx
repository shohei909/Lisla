package litll.idl.generator.output.litll2entity.match;

class FirstElementCondition 
{
    public var canBeEmpty:Bool;
    public var conditions(default, null):Array<LitllToEntityCaseCondition>;
    
    public function new(canBeEmpty:Bool, conditions:Array<LitllToEntityCaseCondition>) 
    {
        this.canBeEmpty = canBeEmpty;
        this.conditions = conditions;
    }
    
    public function addConditions(newConditions:Array<LitllToEntityCaseCondition>):Void
    {
        for (condition in newConditions)
        {
            conditions.push(condition);
        }
    }
}

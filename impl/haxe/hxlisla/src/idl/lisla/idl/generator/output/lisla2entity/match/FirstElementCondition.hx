package lisla.idl.generator.output.lisla2entity.match;

class FirstElementCondition 
{
    public var canBeEmpty:Bool;
    public var conditions(default, null):Array<LislaToEntityCaseCondition>;
    
    public function new(canBeEmpty:Bool, conditions:Array<LislaToEntityCaseCondition>) 
    {
        this.canBeEmpty = canBeEmpty;
        this.conditions = conditions;
    }
    
    public function addConditions(newConditions:Array<LislaToEntityCaseCondition>):Void
    {
        for (condition in newConditions)
        {
            conditions.push(condition);
        }
    }
}

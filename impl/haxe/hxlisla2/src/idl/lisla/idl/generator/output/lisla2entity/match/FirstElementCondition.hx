package arraytree.idl.generator.output.arraytree2entity.match;

class FirstElementCondition 
{
    public var canBeEmpty:Bool;
    public var conditions(default, null):Array<ArrayTreeToEntityCaseCondition>;
    
    public function new(canBeEmpty:Bool, conditions:Array<ArrayTreeToEntityCaseCondition>) 
    {
        this.canBeEmpty = canBeEmpty;
        this.conditions = conditions;
    }
    
    public function addConditions(newConditions:Array<ArrayTreeToEntityCaseCondition>):Void
    {
        for (condition in newConditions)
        {
            conditions.push(condition);
        }
    }
}

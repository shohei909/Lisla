package litll.idl.generator.output.delitll.match;

class FirstElementCondition 
{
    public var canBeEmpty:Bool;
    public var conditions(default, null):Array<DelitllfyCaseCondition>;
    
    public function new(canBeEmpty:Bool, conditions:Array<DelitllfyCaseCondition>) 
    {
        this.canBeEmpty = canBeEmpty;
        this.conditions = conditions;
    }
    
    public function addConditions(newConditions:Array<DelitllfyCaseCondition>):Void
    {
        for (condition in newConditions)
        {
            conditions.push(condition);
        }
    }
}

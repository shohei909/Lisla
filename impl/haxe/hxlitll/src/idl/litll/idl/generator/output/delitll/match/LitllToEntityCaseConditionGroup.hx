package litll.idl.generator.output.delitll.match;
import haxe.ds.Option;
import litll.core.ds.Maybe;
import litll.core.tag.StringTag;

class LitllToEntityCaseConditionGroup<T>
{
    public var name:T;
    public var conditions(default, null):Array<LitllToEntityCaseCondition>;
    
    public function new(name:T, conditions:Array<LitllToEntityCaseCondition>) 
    {
        this.name = name;
        this.conditions = conditions;
    }
    
    public static function intersects<T>(groups:Iterable<LitllToEntityCaseConditionGroup<T>>):Option<{group0:LitllToEntityCaseConditionGroup<T>, group1:LitllToEntityCaseConditionGroup<T>}>
    {
        var processedGroups:Array<LitllToEntityCaseConditionGroup<T>> = [];
        
        for (group in groups)
        {
            for (newCondition in group.conditions)
            {
                for (processedGroup in processedGroups)
                {
                    for (existingCondition in processedGroup.conditions)
                    {
                        if (LitllToEntityCaseConditionTools.intersects(existingCondition, newCondition))
                        {
                            return Option.Some({group0:processedGroup, group1:group});
                        }
                    }
                }
            }
            
            processedGroups.push(group);
        }
        
        return Option.None;
    }
}

package litll.idl.generator.output.delitll.match;
import haxe.ds.Option;
import litll.core.ds.Maybe;
import litll.core.tag.StringTag;

class LitllToBackendCaseConditionGroup<T>
{
    public var name:T;
    public var conditions(default, null):Array<LitllToBackendCaseCondition>;
    
    public function new(name:T, conditions:Array<LitllToBackendCaseCondition>) 
    {
        this.name = name;
        this.conditions = conditions;
    }
    
    public static function intersects<T>(groups:Iterable<LitllToBackendCaseConditionGroup<T>>):Option<{group0:LitllToBackendCaseConditionGroup<T>, group1:LitllToBackendCaseConditionGroup<T>}>
    {
        var processedGroups:Array<LitllToBackendCaseConditionGroup<T>> = [];
        
        for (group in groups)
        {
            for (newCondition in group.conditions)
            {
                for (processedGroup in processedGroups)
                {
                    for (existingCondition in processedGroup.conditions)
                    {
                        if (LitllToBackendCaseConditionTools.intersects(existingCondition, newCondition))
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

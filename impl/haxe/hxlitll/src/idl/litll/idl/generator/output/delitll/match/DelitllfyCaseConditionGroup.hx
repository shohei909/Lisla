package litll.idl.generator.output.delitll.match;
import haxe.ds.Option;
import litll.core.ds.Maybe;
import litll.core.tag.StringTag;

class DelitllfyCaseConditionGroup<T>
{
    public var name:T;
    public var conditions(default, null):Array<DelitllfyCaseCondition>;
    
    public function new(name:T, conditions:Array<DelitllfyCaseCondition>) 
    {
        this.name = name;
        this.conditions = conditions;
    }
    
    public static function intersects<T>(groups:Iterable<DelitllfyCaseConditionGroup<T>>):Option<{group0:DelitllfyCaseConditionGroup<T>, group1:DelitllfyCaseConditionGroup<T>}>
    {
        var processedGroups:Array<DelitllfyCaseConditionGroup<T>> = [];
        
        for (group in groups)
        {
            for (newCondition in group.conditions)
            {
                for (processedGroup in processedGroups)
                {
                    for (existingCondition in processedGroup.conditions)
                    {
                        if (DelitllfyCaseConditionTools.intersects(existingCondition, newCondition))
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

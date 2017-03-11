package lisla.idl.generator.output.lisla2entity.match;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.core.tag.StringTag;

class LislaToEntityCaseConditionGroup<T>
{
    public var name:T;
    public var conditions(default, null):Array<LislaToEntityCaseCondition>;
    
    public function new(name:T, conditions:Array<LislaToEntityCaseCondition>) 
    {
        this.name = name;
        this.conditions = conditions;
    }
    
    public static function intersects<T>(groups:Iterable<LislaToEntityCaseConditionGroup<T>>):Option<{group0:LislaToEntityCaseConditionGroup<T>, group1:LislaToEntityCaseConditionGroup<T>}>
    {
        var processedGroups:Array<LislaToEntityCaseConditionGroup<T>> = [];
        
        for (group in groups)
        {
            for (newCondition in group.conditions)
            {
                for (processedGroup in processedGroups)
                {
                    for (existingCondition in processedGroup.conditions)
                    {
                        if (LislaToEntityCaseConditionTools.intersects(existingCondition, newCondition))
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

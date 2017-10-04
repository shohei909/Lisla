package arraytree.idl.generator.output.arraytree2entity.match;
import haxe.ds.Option;
import hxext.ds.Maybe;
import arraytree.data.meta.core.Metadata;

class ArrayTreeToEntityCaseConditionGroup<T>
{
    public var name:T;
    public var conditions(default, null):Array<ArrayTreeToEntityCaseCondition>;
    
    public function new(name:T, conditions:Array<ArrayTreeToEntityCaseCondition>) 
    {
        this.name = name;
        this.conditions = conditions;
    }
    
    public static function intersects<T>(groups:Iterable<ArrayTreeToEntityCaseConditionGroup<T>>):Option<{group0:ArrayTreeToEntityCaseConditionGroup<T>, group1:ArrayTreeToEntityCaseConditionGroup<T>}>
    {
        var processedGroups:Array<ArrayTreeToEntityCaseConditionGroup<T>> = [];
        
        for (group in groups)
        {
            for (newCondition in group.conditions)
            {
                for (processedGroup in processedGroups)
                {
                    for (existingCondition in processedGroup.conditions)
                    {
                        if (ArrayTreeToEntityCaseConditionTools.intersects(existingCondition, newCondition))
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

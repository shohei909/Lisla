package lisla.idl.generator.output.lisla2entity.match;
import haxe.ds.Option;
using lisla.idl.generator.output.lisla2entity.match.LislaToEntityGuardConditionKindTools;

class LislaToEntityGuardConditionBuilder 
{
    private var min:Int = 0;
    private var max:Option<Int>;
    private var conditions:Array<LislaToEntityGuardConditionKind>;
    public var position(get, never):Int;
    
    private inline function get_position():Int 
    {
        return conditions.length;
    }
    
    public function new() 
    {
        min = 0;
        max = Option.Some(0);
        conditions = [];
    }
    
    public function build():LislaToEntityGuardCondition
    {
        return new LislaToEntityGuardCondition(min, max, conditions);
    }
    
    public inline function add(kind:LislaToEntityGuardConditionKind):Void
    {
        if (isSolid())
        {
            conditions.push(kind);
        }
        
        _add();
    }
    
    private inline function _add():Void
    {
        min++;
        addMax();
    }
    
    public inline function addMax():Void
    {
        switch (max)
        {
            case Option.Some(value):
                max = Option.Some(value + 1);
                
            case Option.None:
        }
    }
    
    public inline function unlimit():Void
    {
        max = Option.None;
    }
    
    public function isSolid():Bool
    {
        return switch (max)
        {
            case Option.Some(value) if (value == min):
                true;
                
            case _:
                false;
        }
    }
    
    public function commonize(startPosition:Int):Void
    {
        var condition;
        if (isSolid())
        {
            condition = LislaToEntityGuardConditionKind.Always;
        }
        else
        {
            condition = LislaToEntityGuardConditionKind.Never;
            for (i in startPosition...conditions.length)
            {
                condition = condition.merge(conditions[i]);
            }
        }
        
        for (i in startPosition...conditions.length)
        {
            conditions[i] = condition;
        }
    }
}
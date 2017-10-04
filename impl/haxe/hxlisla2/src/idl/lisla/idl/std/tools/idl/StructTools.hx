package arraytree.idl.std.tools.idl;
import haxe.ds.Option;
import hxext.ds.Result;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityCaseCondition;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityGuardCondition;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityGuardConditionBuilder;
import arraytree.idl.generator.output.arraytree2entity.match.FirstElementCondition;
import arraytree.idl.generator.source.IdlSourceProvider;
import arraytree.idl.std.entity.idl.ArgumentName;
import arraytree.idl.std.entity.idl.StructElement;
import arraytree.idl.std.entity.idl.TupleElement;
import arraytree.idl.std.entity.idl.TypeName;
import arraytree.idl.std.error.ArgumentSuffixErrorKind;
import arraytree.idl.std.error.GetConditionError;
import arraytree.idl.std.error.GetConditionErrorKind;

class StructTools 
{    
    public static function getGuard(elements:Array<StructElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<ArrayTreeToEntityGuardCondition, GetConditionError>
    {
        var builder = new ArrayTreeToEntityGuardConditionBuilder();
        return switch (_getGuard(elements, source, definitionParameters, builder))
        {
            case Option.None:
                Result.Ok(builder.build());
                
            case Option.Some(error):
                Result.Error(error);
        }
    }
    
    public static function _getGuard(
        elements:Array<StructElement>, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        builder:ArrayTreeToEntityGuardConditionBuilder
    ):Option<GetConditionError>
    {
        var position = builder.position;
        for (element in elements)
        {
            switch (StructElementTools._getGuardForStruct(element, source, definitionParameters, builder))
            {
                case Option.None:
                    
                case Option.Some(error):
                    return Option.Some(error);
            }
        }
        
        builder.commonize(position);
        return Option.None;
    }
    
    public static function getCondition(
        elements:Array<StructElement>, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>
    ):Result<ArrayTreeToEntityCaseCondition, GetConditionError>
    {
        return switch (getGuard(elements, source, definitionParameters))
        {
            case Result.Ok(data):
                Result.Ok(ArrayTreeToEntityCaseCondition.Arr(data));
                
            case Result.Error(error):
                Result.Error(error);
        }
    }
    
    public static function _getConditionsForMerge(
        elements:Array<StructElement>, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        conditions:Array<ArrayTreeToEntityCaseCondition>,
        history:Array<String>
    ):Option<GetConditionError>
    {
        for (element in elements)
        {
            switch (StructElementTools._getConditions(element, source, definitionParameters, conditions, history))
            {
                case Option.None:
                    // continue
                    
                case Option.Some(err):
                    return Option.Some(err);
            }
        }
        
        return Option.None;
    }
    
    public static function getFixedLength(elements:Array<StructElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<Option<Int>, GetConditionError>
    {
        return switch (getGuard(elements, source, definitionParameters))
        {
            case Result.Ok(condition):
                Result.Ok(condition.getFixedLength());
                
            case Result.Error(error):
                Result.Error(error);
        }
    }
    
    public static function getFirstElementCondition(
        elements:Array<StructElement>, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>,
        history:Array<String>
    ):Result<FirstElementCondition, GetConditionError>
    {
        var condition = new FirstElementCondition(true, []);
        return switch (applyFirstElementCondition(elements, source, definitionParameters, condition, history))
        {
            case Option.None:
                Result.Ok(condition);
                
            case Option.Some(error):
                Result.Error(error);
        }
    }
    
    
    public static function applyFirstElementCondition(
        elements:Array<StructElement>, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        condition:FirstElementCondition,
        history:Array<String>
    ):Option<GetConditionError>
    {
        for (element in elements)
        {
            switch (StructElementTools.applyFirstElementCondition(element, source, definitionParameters, condition, history))
            {
                case Option.None:
                    // continue
                    
                case Option.Some(error):
                    return Option.Some(error);
            }
        }
        
        return Option.None;
    }
}

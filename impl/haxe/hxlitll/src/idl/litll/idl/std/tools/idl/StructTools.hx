package litll.idl.std.tools.idl;
import haxe.ds.Option;
import hxext.ds.Result;
import litll.idl.generator.output.litll2entity.match.LitllToEntityCaseCondition;
import litll.idl.generator.output.litll2entity.match.LitllToEntityGuardCondition;
import litll.idl.generator.output.litll2entity.match.LitllToEntityGuardConditionBuilder;
import litll.idl.generator.output.litll2entity.match.FirstElementCondition;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.error.ArgumentSuffixErrorKind;
import litll.idl.std.error.GetConditionErrorKind;

class StructTools 
{    
    public static function getGuard(elements:Array<StructElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<LitllToEntityGuardCondition, GetConditionErrorKind>
    {
        var builder = new LitllToEntityGuardConditionBuilder();
        return switch (_getGuard(elements, source, definitionParameters, builder))
        {
            case Option.None:
                Result.Ok(builder.build());
                
            case Option.Some(error):
                Result.Err(error);
        }
    }
    
    public static function _getGuard(elements:Array<StructElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>, builder:LitllToEntityGuardConditionBuilder):Option<GetConditionErrorKind>
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
    
    public static function getCondition(elements:Array<StructElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<LitllToEntityCaseCondition, GetConditionErrorKind>
    {
        return switch (getGuard(elements, source, definitionParameters))
        {
            case Result.Ok(data):
                Result.Ok(LitllToEntityCaseCondition.Arr(data));
                
            case Result.Err(error):
                Result.Err(error);
        }
    }
    
    public static function _getConditionsForMerge(
        elements:Array<StructElement>, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        conditions:Array<LitllToEntityCaseCondition>,
        history:Array<String>
    ):Option<GetConditionErrorKind>
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
    
    public static function getFixedLength(elements:Array<StructElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<Option<Int>, GetConditionErrorKind>
    {
        return switch (getGuard(elements, source, definitionParameters))
        {
            case Result.Ok(condition):
                Result.Ok(condition.getFixedLength());
                
            case Result.Err(error):
                Result.Err(error);
        }
    }
    
    public static function getFirstElementCondition(
        elements:Array<StructElement>, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>,
        history:Array<String>
    ):Result<FirstElementCondition, GetConditionErrorKind>
    {
        var condition = new FirstElementCondition(true, []);
        return switch (applyFirstElementCondition(elements, source, definitionParameters, condition, history))
        {
            case Option.None:
                Result.Ok(condition);
                
            case Option.Some(error):
                Result.Err(error);
        }
    }
    
    
    public static function applyFirstElementCondition(
        elements:Array<StructElement>, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        condition:FirstElementCondition,
        history:Array<String>
    ):Option<GetConditionErrorKind>
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

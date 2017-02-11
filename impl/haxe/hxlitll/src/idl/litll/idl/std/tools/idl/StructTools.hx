package litll.idl.std.tools.idl;
import haxe.ds.Option;
import litll.core.ds.Result;
import litll.idl.generator.output.delitll.match.DelitllfyCaseCondition;
import litll.idl.generator.output.delitll.match.DelitllfyGuardCondition;
import litll.idl.generator.output.delitll.match.DelitllfyGuardConditionBuilder;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.error.GetConditionErrorKind;

class StructTools 
{    
    public static function getGuard(elements:Array<StructElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<DelitllfyGuardCondition, GetConditionErrorKind>
    {
        var builder = new DelitllfyGuardConditionBuilder();
        return switch (_getGuard(elements, source, definitionParameters, builder))
        {
            case Option.None:
                Result.Ok(builder.build());
                
            case Option.Some(error):
                Result.Err(error);
        }
    }
    
    public static function _getGuard(elements:Array<StructElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>, builder:DelitllfyGuardConditionBuilder):Option<GetConditionErrorKind>
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
    
    public static function getCondition(elements:Array<StructElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<DelitllfyCaseCondition, GetConditionErrorKind>
    {
        return switch (getGuard(elements, source, definitionParameters))
        {
            case Result.Ok(data):
                Result.Ok(DelitllfyCaseCondition.Arr(data));
                
            case Result.Err(error):
                Result.Err(error);
        }
    }
    
    public static function _getConditionsForMerge(
        elements:Array<StructElement>, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        conditions:Array<DelitllfyCaseCondition>,
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
}

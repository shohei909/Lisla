package litll.idl.std.tools.idl;
import haxe.ds.Option;
import hxext.ds.Result;
import litll.idl.generator.output.litll2entity.match.LitllToEntityCaseCondition;
import litll.idl.generator.output.litll2entity.match.LitllToEntityGuardCondition;
import litll.idl.generator.output.litll2entity.match.FirstElementCondition;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.FollowedTypeDefinition;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.error.ArgumentSuffixErrorKind;
import litll.idl.std.error.GetConditionErrorKind;

class FollowedTypeDefinitionTools 
{
    public static function getConditions(type:FollowedTypeDefinition, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<Array<LitllToEntityCaseCondition>, GetConditionErrorKind>
    {
        var result:Array<LitllToEntityCaseCondition> = [];
        return switch (_getConditions(type, source, definitionParameters, result, []))
        {
            case Option.None:
                Result.Ok(result);
                
            case Option.Some(error):
                Result.Err(error);
        }
    }
    
    public static function _getConditions(
        type:FollowedTypeDefinition, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        result:Array<LitllToEntityCaseCondition>,
        enumInlineTypeHistory:Array<String>
    ):Option<GetConditionErrorKind>
    {   
        switch (type)
        {
            case FollowedTypeDefinition.Arr(_):
                result.push(LitllToEntityCaseCondition.Arr(LitllToEntityGuardCondition.any()));
                
            case FollowedTypeDefinition.Str:
                result.push(LitllToEntityCaseCondition.Str);
                
            case FollowedTypeDefinition.Tuple(elements):
                switch (TupleTools.getCondition(elements, source, definitionParameters))
                {
                    case Result.Ok(data):
                        result.push(data);
                        
                    case Result.Err(error):
                        return Option.Some(error);
                }
                
            case FollowedTypeDefinition.Enum(constructors):
                for (constuctor in constructors)
                {
                    switch (EnumConstructorTools._getConditions(constuctor, source, definitionParameters, result, enumInlineTypeHistory))
                    {
                        case Option.None:
                            // continue
                            
                        case Option.Some(error):
                            return Option.Some(error);
                    }
                }
                
            case FollowedTypeDefinition.Struct(elements):
                switch (StructTools.getCondition(elements, source, definitionParameters))
                {
                    case Result.Ok(data):
                        result.push(data);
                        
                    case Result.Err(error):
                        return Option.Some(error);
                }
        }
        
        return Option.None;
    }
    
    public static function getFirstElementCondition(
        type:FollowedTypeDefinition, 
        argumentName:ArgumentName, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>,
        tupleInlineTypeHistory:Array<String>,
        enumInlineTypeHistory:Array<String>
    ):Result<FirstElementCondition, GetConditionErrorKind>
    {
        return switch (type)
        {
            case FollowedTypeDefinition.Arr(_):
                Result.Ok(new FirstElementCondition(true, []));
                
            case FollowedTypeDefinition.Str:
                Result.Err(argumentName.errorKind(ArgumentSuffixErrorKind.InlineString));
                
            case FollowedTypeDefinition.Tuple(elements):
                elements.getFirstElementCondition(source, definitionParameters, tupleInlineTypeHistory);
                
            case FollowedTypeDefinition.Struct(elements):
                elements.getFirstElementCondition(source, definitionParameters, []);
                
            case FollowedTypeDefinition.Enum(constructors):
                constructors.getFirstElementCondition(argumentName, source, definitionParameters, tupleInlineTypeHistory, enumInlineTypeHistory);
        }
    }
    
    public static function getNotEmptyFirstElementCondition(
        type:FollowedTypeDefinition, 
        argumentName:ArgumentName, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>,
        tupleInlineTypeHistory:Array<String>,
        enumInlineTypeHistory:Array<String>
    ):Result<Array<LitllToEntityCaseCondition>, GetConditionErrorKind>
    {
        return switch (getFirstElementCondition(type, argumentName, source, definitionParameters, tupleInlineTypeHistory, enumInlineTypeHistory))
        {
            case Result.Ok(condition):
                if (condition.canBeEmpty)
                {
                    Result.Err(argumentName.errorKind(ArgumentSuffixErrorKind.FirstElementRequired));
                }
                else
                {
                    Result.Ok(condition.conditions);
                }
                
            case Result.Err(error):
                Result.Err(error);
        }
    }
}

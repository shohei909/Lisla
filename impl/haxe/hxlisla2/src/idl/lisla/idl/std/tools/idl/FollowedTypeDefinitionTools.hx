package lisla.idl.std.tools.idl;
import haxe.ds.Option;
import hxext.ds.Result;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityCaseCondition;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityGuardCondition;
import lisla.idl.generator.output.lisla2entity.match.FirstElementCondition;
import lisla.idl.generator.source.IdlSourceProvider;
import lisla.idl.std.entity.idl.ArgumentName;
import lisla.idl.std.entity.idl.FollowedTypeDefinition;
import lisla.idl.std.entity.idl.TupleElement;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.error.ArgumentSuffixErrorKind;
import lisla.idl.std.error.GetConditionError;
import lisla.idl.std.error.GetConditionErrorKind;

class FollowedTypeDefinitionTools 
{
    public static function getConditions(
        type:FollowedTypeDefinition, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>
    ):Result<Array<LislaToEntityCaseCondition>, GetConditionError>
    {
        var result:Array<LislaToEntityCaseCondition> = [];
        return switch (_getConditions(type, source, definitionParameters, result, []))
        {
            case Option.None:
                Result.Ok(result);
                
            case Option.Some(error):
                Result.Error(error);
        }
    }
    
    public static function _getConditions(
        type:FollowedTypeDefinition, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        result:Array<LislaToEntityCaseCondition>,
        enumInlineTypeHistory:Array<String>
    ):Option<GetConditionError>
    {   
        switch (type)
        {
            case FollowedTypeDefinition.Arr(_):
                result.push(LislaToEntityCaseCondition.Arr(LislaToEntityGuardCondition.any()));
                
            case FollowedTypeDefinition.Str:
                result.push(LislaToEntityCaseCondition.Str);
                
            case FollowedTypeDefinition.Tuple(elements):
                switch (TupleTools.getCondition(elements, source, definitionParameters))
                {
                    case Result.Ok(data):
                        result.push(data);
                        
                    case Result.Error(error):
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
                        
                    case Result.Error(error):
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
    ):Result<FirstElementCondition, GetConditionError>
    {
        return switch (type)
        {
            case FollowedTypeDefinition.Arr(_):
                Result.Ok(new FirstElementCondition(true, []));
                
            case FollowedTypeDefinition.Str:
                Result.Error(argumentName.error(ArgumentSuffixErrorKind.InlineString));
                
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
    ):Result<Array<LislaToEntityCaseCondition>, GetConditionError>
    {
        return switch (getFirstElementCondition(type, argumentName, source, definitionParameters, tupleInlineTypeHistory, enumInlineTypeHistory))
        {
            case Result.Ok(condition):
                if (condition.canBeEmpty)
                {
                    Result.Error(argumentName.error(ArgumentSuffixErrorKind.FirstElementRequired));
                }
                else
                {
                    Result.Ok(condition.conditions);
                }
                
            case Result.Error(error):
                Result.Error(error);
        }
    }
}

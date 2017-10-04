package arraytree.idl.std.tools.idl;
import haxe.ds.Option;
import hxext.ds.Result;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityCaseCondition;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityGuardCondition;
import arraytree.idl.generator.output.arraytree2entity.match.FirstElementCondition;
import arraytree.idl.generator.source.IdlSourceProvider;
import arraytree.idl.std.entity.idl.ArgumentName;
import arraytree.idl.std.entity.idl.FollowedTypeDefinition;
import arraytree.idl.std.entity.idl.TupleElement;
import arraytree.idl.std.entity.idl.TypeName;
import arraytree.idl.std.error.ArgumentSuffixErrorKind;
import arraytree.idl.std.error.GetConditionError;
import arraytree.idl.std.error.GetConditionErrorKind;

class FollowedTypeDefinitionTools 
{
    public static function getConditions(
        type:FollowedTypeDefinition, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>
    ):Result<Array<ArrayTreeToEntityCaseCondition>, GetConditionError>
    {
        var result:Array<ArrayTreeToEntityCaseCondition> = [];
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
        result:Array<ArrayTreeToEntityCaseCondition>,
        enumInlineTypeHistory:Array<String>
    ):Option<GetConditionError>
    {   
        switch (type)
        {
            case FollowedTypeDefinition.Arr(_):
                result.push(ArrayTreeToEntityCaseCondition.Arr(ArrayTreeToEntityGuardCondition.any()));
                
            case FollowedTypeDefinition.Str:
                result.push(ArrayTreeToEntityCaseCondition.Str);
                
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
    ):Result<Array<ArrayTreeToEntityCaseCondition>, GetConditionError>
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

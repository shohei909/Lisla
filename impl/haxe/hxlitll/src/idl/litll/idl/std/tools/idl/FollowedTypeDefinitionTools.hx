package litll.idl.std.tools.idl;
import haxe.ds.Option;
import litll.core.ds.Result;
import litll.idl.generator.output.delitll.match.DelitllfyCaseCondition;
import litll.idl.generator.output.delitll.match.DelitllfyGuardCondition;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.FollowedTypeDefinition;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.error.GetConditionErrorKind;

class FollowedTypeDefinitionTools 
{
    public static function getConditions(type:FollowedTypeDefinition, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<Array<DelitllfyCaseCondition>, GetConditionErrorKind>
    {
        var result:Array<DelitllfyCaseCondition> = [];
        return switch (_getConditions(type, source, definitionParameters, result))
        {
            case Option.None:
                Result.Ok(result);
                
            case Option.Some(error):
                Result.Err(error);
        }
    }   
    
    public static function _getConditions(type:FollowedTypeDefinition, source:IdlSourceProvider, definitionParameters:Array<TypeName>, result:Array<DelitllfyCaseCondition>):Option<GetConditionErrorKind>
    {   
        switch (type)
        {
            case FollowedTypeDefinition.Arr(_):
                result.push(DelitllfyCaseCondition.Arr(DelitllfyGuardCondition.any()));
                
            case FollowedTypeDefinition.Str:
                result.push(DelitllfyCaseCondition.Str);
                
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
                    switch (EnumConstructorTools._getConditions(constuctor, source, definitionParameters, result))
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
}

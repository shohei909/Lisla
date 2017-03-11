package litll.idl.std.tools.idl;
import haxe.ds.Option;
import hxext.ds.Result;
import litll.idl.generator.output.litll2entity.match.LitllToEntityCaseCondition;
import litll.idl.generator.output.litll2entity.match.LitllToEntityGuardConditionKind;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.entity.idl.Argument;
import litll.idl.std.entity.idl.ArgumentName;
import litll.idl.std.entity.idl.FollowedTypeDefinition;
import litll.idl.std.entity.idl.TupleElement;
import litll.idl.std.entity.idl.TypeName;
import litll.idl.std.entity.idl.TypeReference;
import litll.idl.std.error.ArgumentSuffixError;
import litll.idl.std.error.ArgumentSuffixErrorKind;
import litll.idl.std.error.GetConditionErrorKind;
import litll.idl.std.tools.idl.TypeReferenceTools;

class ArgumentTools 
{
    public static function mapOverTypeReference(argument:Argument, func:TypeReference-> TypeReference):Argument
    {
        return new Argument(
            argument.name, 
            func(argument.type), 
            argument.defaultValue
        );
    }
    
    public static function getFixedLength(argument:Argument, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<Option<Int>, GetConditionErrorKind>
    {
        return switch (argument.type.getConditions(source, definitionParameters))
        {
            case Result.Ok(conditions):
                var length = Option.None;
                for (condition in conditions)
                {
                    switch (condition)
                    {
                        case LitllToEntityCaseCondition.Arr(guard):
                            switch [length, guard.getFixedLength()]
                            {
                                case [_, Option.None]:
                                    length = Option.None;
                                    break;
                                    
                                case [Option.None, Option.Some(value)]:
                                    length = Option.Some(value);
                                    
                                case [Option.Some(value0), Option.Some(value1)]:
                                    if (value0 != value1)
                                    {
                                        length = Option.None;
                                        break;
                                    }
                            }
                            
                        case LitllToEntityCaseCondition.Str | LitllToEntityCaseCondition.Const(_):
                            return Result.Err(errorKind(argument.name, ArgumentSuffixErrorKind.InlineString));
                    }
                }
                
                Result.Ok(length);
            
            case Result.Err(error):
                Result.Err(error);
        }
    }
    
    public static inline function errorKind(name:ArgumentName, error:ArgumentSuffixErrorKind):GetConditionErrorKind
    {
        return GetConditionErrorKind.TupleArgumentSuffix(
            new ArgumentSuffixError(name, error)
        );
    }
}

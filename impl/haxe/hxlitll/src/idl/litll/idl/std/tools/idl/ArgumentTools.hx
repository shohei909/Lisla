package litll.idl.std.tools.idl;
import haxe.ds.Option;
import litll.core.ds.Result;
import litll.idl.generator.output.delitll.match.DelitllfyCaseCondition;
import litll.idl.generator.output.delitll.match.DelitllfyGuardConditionKind;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.FollowedTypeDefinition;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeReference;
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
                        case DelitllfyCaseCondition.Arr(guard):
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
                            
                        case DelitllfyCaseCondition.Str | DelitllfyCaseCondition.Const(_):
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

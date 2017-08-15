package lisla.idl.std.tools.idl;
import haxe.ds.Option;
import hxext.ds.Result;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityCaseCondition;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityGuardConditionKind;
import lisla.idl.generator.source.IdlSourceProvider;
import lisla.idl.std.entity.idl.Argument;
import lisla.idl.std.entity.idl.ArgumentName;
import lisla.idl.std.entity.idl.FollowedTypeDefinition;
import lisla.idl.std.entity.idl.TupleElement;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.entity.idl.TypeReference;
import lisla.idl.std.error.ArgumentSuffixError;
import lisla.idl.std.error.ArgumentSuffixErrorKind;
import lisla.idl.std.error.GetConditionError;
import lisla.idl.std.error.GetConditionErrorKind;
import lisla.idl.std.tools.idl.TypeReferenceTools;

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
    
    public static function getFixedLength(argument:Argument, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<Option<Int>, GetConditionError>
    {
        return switch (argument.type.getConditions(source, definitionParameters))
        {
            case Result.Ok(conditions):
                var length = Option.None;
                for (condition in conditions)
                {
                    switch (condition)
                    {
                        case LislaToEntityCaseCondition.Arr(guard):
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
                            
                        case LislaToEntityCaseCondition.Str | LislaToEntityCaseCondition.Const(_):
                            return Result.Error(error(argument.name, ArgumentSuffixErrorKind.InlineString));
                    }
                }
                
                Result.Ok(length);
            
            case Result.Error(error):
                Result.Error(error);
        }
    }
    
    public static inline function error(name:ArgumentName, error:ArgumentSuffixErrorKind):GetConditionError
    {
        return new GetConditionError(
            GetConditionErrorKind.TupleArgumentSuffix(
                new ArgumentSuffixError(name, error)
            )
        );
    }
}

package arraytree.idl.std.tools.idl;
import haxe.ds.Option;
import hxext.ds.Result;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityCaseCondition;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityGuardConditionKind;
import arraytree.idl.generator.source.IdlSourceProvider;
import arraytree.idl.std.entity.idl.Argument;
import arraytree.idl.std.entity.idl.ArgumentName;
import arraytree.idl.std.entity.idl.FollowedTypeDefinition;
import arraytree.idl.std.entity.idl.TupleElement;
import arraytree.idl.std.entity.idl.TypeName;
import arraytree.idl.std.entity.idl.TypeReference;
import arraytree.idl.std.error.ArgumentSuffixError;
import arraytree.idl.std.error.ArgumentSuffixErrorKind;
import arraytree.idl.std.error.GetConditionError;
import arraytree.idl.std.error.GetConditionErrorKind;
import arraytree.idl.std.tools.idl.TypeReferenceTools;

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
                        case ArrayTreeToEntityCaseCondition.Arr(guard):
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
                            
                        case ArrayTreeToEntityCaseCondition.Str | ArrayTreeToEntityCaseCondition.Const(_):
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

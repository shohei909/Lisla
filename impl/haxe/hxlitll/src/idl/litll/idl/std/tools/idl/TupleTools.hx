package litll.idl.std.tools.idl;
import haxe.ds.Option;
import litll.core.ds.Result;
import litll.idl.generator.output.delitll.match.DelitllfyCaseCondition;
import litll.idl.generator.output.delitll.match.DelitllfyGuardCondition;
import litll.idl.generator.output.delitll.match.DelitllfyGuardConditionBuilder;
import litll.idl.generator.output.delitll.match.DelitllfyGuardConditionKind;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.ArgumentKind;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.FollowedTypeDefinition;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.error.ArgumentSuffixError;
import litll.idl.std.error.ArgumentSuffixErrorKind;
import litll.idl.std.error.GetConditionErrorKind;
using litll.idl.std.tools.idl.TypeReferenceParameterTools;
using litll.idl.std.tools.idl.TypeReferenceTools;

class TupleTools 
{
    private static inline function argumentError(name:ArgumentName, error:ArgumentSuffixErrorKind):Option<GetConditionErrorKind>
    {
        return Option.Some(
            GetConditionErrorKind.TupleArgumentSuffix(
                new ArgumentSuffixError(name, error)
            )
        );
    }
    
    public static function getGuard(elements:Array<TupleElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<DelitllfyGuardCondition, GetConditionErrorKind>
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
    
    public static function _getGuard(
        elements:Array<TupleElement>, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        builder:DelitllfyGuardConditionBuilder
    ):Option<GetConditionErrorKind>
    {
    
        for (element in elements)
        {
            switch (element)
            {
                case TupleElement.Label(value):
                    builder.add(DelitllfyGuardConditionKind.Const([value.data => true]));
                    
                case TupleElement.Argument(argument):
                    switch [argument.name.kind, argument.defaultValue]
                    {
                        case [ArgumentKind.Normal, Option.None]:
                            switch (TypeReferenceTools.getGuardConditionKind(argument.type, source, definitionParameters))
                            {
                                case Result.Ok(data):
                                    builder.add(data);
                                    
                                case Result.Err(error):
                                    return Option.Some(error);
                            }
                            
                        case [ArgumentKind.Optional, Option.None] 
                            | [ArgumentKind.Normal, Option.Some(_)]:
                            builder.addMax();
                        
                        case [ArgumentKind.Rest, Option.None]:
                            builder.unlimit();
                        
                        case [ArgumentKind.Inline, Option.None]:
                            switch (argument.type.follow(source, definitionParameters))
                            {
                                case Result.Ok(data):
                                    switch (data)
                                    {
                                        case FollowedTypeDefinition.Arr(_):
                                            builder.unlimit();
                                            
                                        case FollowedTypeDefinition.Struct(elements):
                                            StructTools._getGuard(elements, source, definitionParameters, builder);
                                            
                                        case FollowedTypeDefinition.Tuple(elements):
                                            TupleTools._getGuard(elements, source, definitionParameters, builder);
                                            
                                        case FollowedTypeDefinition.Str:
                                            return argumentError(argument.name, ArgumentSuffixErrorKind.InlineString);
                                            
                                        case FollowedTypeDefinition.Enum(_):
                                            builder.unlimit();
                                    }
                                    
                                case Result.Err(error):
                                    return Option.Some(GetConditionErrorKind.Follow(error));
                            }
                            
                        case [ArgumentKind.Rest, Option.Some(_)] 
                            | [ArgumentKind.Inline, Option.Some(_)]
                            | [ArgumentKind.Optional, Option.Some(_)]:
                            return argumentError(argument.name, ArgumentSuffixErrorKind.UnsupportedDefault(argument.name.kind));
                    }
            }
        }
        
        return Option.None;
    }
    
    public static function getCondition(elements:Array<TupleElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<DelitllfyCaseCondition, GetConditionErrorKind>
    {
        return switch (getGuard(elements, source, definitionParameters))
        {
            case Result.Ok(data):
                Result.Ok(DelitllfyCaseCondition.Arr(data));
                
            case Result.Err(error):
                Result.Err(error);
        }
    }
}

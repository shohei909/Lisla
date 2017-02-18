package litll.idl.std.tools.idl;

import haxe.ds.Option;
import litll.core.ds.Result;
import litll.idl.generator.output.delitll.match.LitllToEntityCaseCondition;
import litll.idl.generator.output.delitll.match.LitllToEntityGuardCondition;
import litll.idl.generator.output.delitll.match.LitllToEntityGuardConditionBuilder;
import litll.idl.generator.output.delitll.match.LitllToEntityGuardConditionKind;
import litll.idl.generator.output.delitll.match.FirstElementCondition;
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
    
    public static function getGuard(elements:Array<TupleElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<LitllToEntityGuardCondition, GetConditionErrorKind>
    {
        var builder = new LitllToEntityGuardConditionBuilder();
        return switch (_getGuard(elements, source, definitionParameters, builder, []))
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
        builder:LitllToEntityGuardConditionBuilder,
        parentTypes:Array<String>
    ):Option<GetConditionErrorKind>
    {
        for (element in elements)
        {
            switch (element)
            {
                case TupleElement.Label(value):
                    builder.add(LitllToEntityGuardConditionKind.Const([value.data => true]));
                    
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
                        
                        case [ArgumentKind.RestInline, Option.None]:
                            // TODO: Check inlinanability
                            builder.unlimit();
                            
                        case [ArgumentKind.Inline, Option.None]:
                            var name = argument.type.getTypePath().toString();
                            if (parentTypes.indexOf(name) == -1)
                            {
                                builder.unlimit();
                            }
                            else
                            {
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
                                                TupleTools._getGuard(elements, source, definitionParameters, builder, parentTypes.concat([name]));
                                                
                                            case FollowedTypeDefinition.Str:
                                                return argumentError(argument.name, ArgumentSuffixErrorKind.InlineString);
                                                
                                            case FollowedTypeDefinition.Enum(_):
                                                // TODO: Check inlinanability
                                                builder.unlimit();
                                        }
                                        
                                    case Result.Err(error):
                                        return Option.Some(GetConditionErrorKind.Follow(error));
                                }
                            }
                            
                        case [ArgumentKind.OptionalInline, Option.None]:
                            var name = argument.type.getTypePath().toString();
                            builder.unlimit();
                            
                            if (parentTypes.indexOf(name) != -1)
                            {
                                switch (argument.type.follow(source, definitionParameters))
                                {
                                    case Result.Ok(data):
                                        switch (data)
                                        {
                                            case FollowedTypeDefinition.Arr(_):
                                                // nothing to do
                                                
                                            case FollowedTypeDefinition.Struct(elements):
                                                builder.unlimit();
                                                StructTools._getGuard(elements, source, definitionParameters, builder);
                                                
                                            case FollowedTypeDefinition.Tuple(elements):
                                                builder.unlimit();
                                                TupleTools._getGuard(elements, source, definitionParameters, builder, parentTypes.concat([name]));
                                                
                                            case FollowedTypeDefinition.Str:
                                                return argumentError(argument.name, ArgumentSuffixErrorKind.InlineString);
                                                
                                            case FollowedTypeDefinition.Enum(_):
                                                // TODO: Check inlinanability
                                        }
                                        
                                    case Result.Err(error):
                                        return Option.Some(GetConditionErrorKind.Follow(error));
                                }
                            }
                            
                        case [ArgumentKind.Rest, Option.Some(_)] 
                            | [ArgumentKind.Inline, Option.Some(_)]
                            | [ArgumentKind.Optional, Option.Some(_)]
                            | [ArgumentKind.OptionalInline, Option.Some(_)]
                            | [ArgumentKind.RestInline, Option.Some(_)]:
                            return argumentError(argument.name, ArgumentSuffixErrorKind.UnsupportedDefault(argument.name.kind));
                    }
            }
        }
        
        return Option.None;
    }
    
    public static function getCondition(elements:Array<TupleElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<LitllToEntityCaseCondition, GetConditionErrorKind>
    {
        return switch (getGuard(elements, source, definitionParameters))
        {
            case Result.Ok(data):
                Result.Ok(LitllToEntityCaseCondition.Arr(data));
                
            case Result.Err(error):
                Result.Err(error);
        }
    }
    
    public static function getFixedLength(elements:Array<TupleElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<Option<Int>, GetConditionErrorKind>
    {
        return switch (getGuard(elements, source, definitionParameters))
        {
            case Result.Ok(condition):
                Result.Ok(condition.getFixedLength());
                
            case Result.Err(error):
                Result.Err(error);
        }
    }
    
    public static function getFirstElementCondition(
        elements:Array<TupleElement>, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        history:Array<String>
    ):Result<FirstElementCondition, GetConditionErrorKind>
    {
        var condition = new FirstElementCondition(true, []);
        return switch (applyFirstElementCondition(elements, source, definitionParameters, condition, history))
        {
            case Option.None:
                Result.Ok(condition);
                
            case Option.Some(error):
                Result.Err(error);
        }
    }
    
    public static function applyFirstElementCondition(
        elements:Array<TupleElement>, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        condition:FirstElementCondition, 
        history:Array<String>
    ):Option<GetConditionErrorKind>
    {
        for (element in elements)
        {
            switch (element.applyFirstElementCondition(source, definitionParameters, condition, []))
            {
                case Option.None:
                    if (!condition.canBeEmpty)
                    {
                        return Option.None;
                    }
                    
                case Option.Some(error):
                    return Option.Some(error);
            }
        }
        
        return Option.None;
    }
}

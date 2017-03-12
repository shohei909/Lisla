package lisla.idl.std.tools.idl;

import haxe.ds.Option;
import hxext.ds.Result;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityCaseCondition;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityGuardCondition;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityGuardConditionBuilder;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityGuardConditionKind;
import lisla.idl.generator.output.lisla2entity.match.FirstElementCondition;
import lisla.idl.generator.source.IdlSourceProvider;
import lisla.idl.std.entity.idl.ArgumentKind;
import lisla.idl.std.entity.idl.ArgumentName;
import lisla.idl.std.entity.idl.FollowedTypeDefinition;
import lisla.idl.std.entity.idl.TupleElement;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.error.ArgumentSuffixError;
import lisla.idl.std.error.ArgumentSuffixErrorKind;
import lisla.idl.std.error.GetConditionErrorKind;
using lisla.idl.std.tools.idl.TypeReferenceParameterTools;
using lisla.idl.std.tools.idl.TypeReferenceTools;

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
    
    public static function getGuard(elements:Array<TupleElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<LislaToEntityGuardCondition, GetConditionErrorKind>
    {
        var builder = new LislaToEntityGuardConditionBuilder();
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
        builder:LislaToEntityGuardConditionBuilder,
        parentTypes:Array<String>
    ):Option<GetConditionErrorKind>
    {
        for (element in elements)
        {
            switch (element)
            {
                case TupleElement.Label(value):
                    builder.add(LislaToEntityGuardConditionKind.Const([value.data => true]));
                    
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
                                                // TODO: EnumTools._getGuard
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
                                                StructTools._getGuard(elements, source, definitionParameters, builder);
                                                
                                            case FollowedTypeDefinition.Tuple(elements):
                                                TupleTools._getGuard(elements, source, definitionParameters, builder, parentTypes.concat([name]));
                                                
                                            case FollowedTypeDefinition.Str:
                                                return argumentError(argument.name, ArgumentSuffixErrorKind.InlineString);
                                                
                                            case FollowedTypeDefinition.Enum(_):
                                                // TODO: Check inlinanability
                                                // TODO: EnumTools._getGuard
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
    
    public static function getCondition(elements:Array<TupleElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<LislaToEntityCaseCondition, GetConditionErrorKind>
    {
        return switch (getGuard(elements, source, definitionParameters))
        {
            case Result.Ok(data):
                Result.Ok(LislaToEntityCaseCondition.Arr(data));
                
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

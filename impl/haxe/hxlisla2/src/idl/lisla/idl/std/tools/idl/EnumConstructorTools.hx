package lisla.idl.std.tools.idl;
import haxe.ds.Option;
import lisla.data.meta.core.StringWithMetadata;
import hxext.ds.Result;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityCaseCondition;
import lisla.idl.generator.output.lisla2entity.match.FirstElementCondition;
import lisla.idl.generator.source.IdlSourceProvider;
import lisla.idl.std.entity.idl.ArgumentName;
import lisla.idl.std.entity.idl.EnumConstructor;
import lisla.idl.std.entity.idl.EnumConstructorKind;
import lisla.idl.std.entity.idl.EnumConstructorName;
import lisla.idl.std.entity.idl.ParameterizedEnumConstructor;
import lisla.idl.std.entity.idl.TupleElement;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.entity.idl.TypeReference;
import lisla.idl.std.error.ArgumentSuffixErrorKind;
import lisla.idl.std.error.EnumConstructorSuffixError;
import lisla.idl.std.error.EnumConstructorSuffixErrorKind;
import lisla.idl.std.error.GetConditionError;
import lisla.idl.std.error.GetConditionErrorKind;

using lisla.idl.std.tools.idl.TypeReferenceTools;

class EnumConstructorTools 
{    
    public static function iterateOverTypeReference(constructor:EnumConstructor, func:TypeReference-> Void) 
    {
        switch (constructor)
        {
            case EnumConstructor.Primitive(_):
                // nothing to do
                
            case EnumConstructor.Parameterized(paramerizedConstructor):
                for (element in paramerizedConstructor.elements)
                {
                    TupleElementTools.iterateOverTypeReference(element, func);
                }
        }
    }
    
    public static function mapOverTypeReference(constructor:EnumConstructor, func:TypeReference->TypeReference):EnumConstructor
    {
        return switch (constructor)
        {
            case EnumConstructor.Primitive(_):
                constructor;
                
            case EnumConstructor.Parameterized(paramerizedConstructor):
                EnumConstructor.Parameterized(
                    new ParameterizedEnumConstructor(
                        paramerizedConstructor.name, 
                        [for (element in paramerizedConstructor.elements) TupleElementTools.mapOverTypeReference(element, func)]
                    )
                );
        }
    }
    
    public static function getConstructorName(constructor:EnumConstructor):EnumConstructorName
    {
        return switch (constructor)
        {
            case EnumConstructor.Primitive(name):
                name;
                
            case EnumConstructor.Parameterized(parameterized):
                parameterized.name;
        }
    }
    
    public static function getConditions(
        constructor:EnumConstructor, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>
    ):Result<Array<LislaToEntityCaseCondition>, GetConditionError>
    {
        var result = [];
        return switch (_getConditions(constructor, source, definitionParameters, result, []))
        {
            case Option.None:
                Result.Ok(result);
                
            case Option.Some(error):
                Result.Error(error);
        }
    }
       
    public static function _getConditions(
        constructor:EnumConstructor, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        result:Array<LislaToEntityCaseCondition>,
        history:Array<String>
    ):Option<GetConditionError>
    {
        return switch (constructor)
        {
            case EnumConstructor.Primitive(name):
                result.push(LislaToEntityCaseCondition.Const(name.name));
                Option.None;
                
            case EnumConstructor.Parameterized(parameterized):
                switch (parameterized.name.kind)
                {
                    case EnumConstructorKind.Normal:
                        var label = TupleElement.Label(new StringWithMetadata(parameterized.name.name, parameterized.name.metadata));
                        switch (TupleTools.getGuard([label].concat(parameterized.elements), source, definitionParameters))
                        {
                            case Result.Ok(data):
                                result.push(LislaToEntityCaseCondition.Arr(data));
                                Option.None;
                                
                            case Result.Error(error):
                                Option.Some(error);
                        }
                        
                    case EnumConstructorKind.Tuple:
                        switch (TupleTools.getGuard(parameterized.elements, source, definitionParameters))
                        {
                            case Result.Ok(data):
                                result.push(LislaToEntityCaseCondition.Arr(data));
                                Option.None;
                                
                            case Result.Error(error):
                                Option.Some(error);
                        }
                        
                    case EnumConstructorKind.Inline:
                        var elements = parameterized.elements;
                        if (elements.length != 1)
                        {
                            Option.Some(error(parameterized.name, EnumConstructorSuffixErrorKind.InvalidInlineEnumConstructorParameterLength(elements.length)));
                        }
                        else
                        {
                            switch (elements[0])
                            {
                                case TupleElement.Argument(argument):
                                    var path = argument.type.getTypePath();
                                    var pathName = path.toString();
                                    if (history.indexOf(pathName) != -1)
                                    {
                                        Option.Some(error(parameterized.name, EnumConstructorSuffixErrorKind.LoopedInline(path)));
                                    }
                                    else
                                    {
                                        switch (argument.type.follow(source, definitionParameters))
                                        {
                                            case Result.Ok(followedType):
                                                FollowedTypeDefinitionTools._getConditions(
                                                    followedType, 
                                                    source, 
                                                    definitionParameters, 
                                                    result,
                                                    history.concat([pathName])
                                                );
                                                
                                            case Result.Error(error):
                                                Option.Some(new GetConditionError(GetConditionErrorKind.Follow(error)));
                                        }
                                    }
                                    
                                case TupleElement.Label(lislaString):
                                    Option.Some(error(parameterized.name, EnumConstructorSuffixErrorKind.InvalidInlineEnumConstructorLabel));
                            }
                        }
                }
        }
    }
    
    private static inline function error(
        name:EnumConstructorName, 
        kind:EnumConstructorSuffixErrorKind
    ):GetConditionError
    {
        return new GetConditionError(
            GetConditionErrorKind.EnumConstructorSuffix(
                new EnumConstructorSuffixError(name, kind)
            )
        );
    }
    
    public static function getOwnedTupleElements(constructor:EnumConstructor):Option<Array<TupleElement>>
    {
        return switch (constructor)
        {
            case EnumConstructor.Primitive(name):
                Option.None;
                
            case EnumConstructor.Parameterized(parameterized):
                switch (parameterized.name.kind)
                {
                    case EnumConstructorKind.Normal:
                        var label = TupleElement.Label(new StringWithMetadata(parameterized.name.name, parameterized.name.metadata));
                        Option.Some([label].concat(parameterized.elements));
                        
                    case EnumConstructorKind.Tuple:
                        Option.Some(parameterized.elements);
                        
                    case EnumConstructorKind.Inline:
                        Option.None;
                }
        }
    }
    
    public static function applyFirstElementCondition(
        constructor:EnumConstructor, 
        argumentName:ArgumentName,  
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        condition:FirstElementCondition, 
        tupleInlineTypeHistory:Array<String>,
        enumInlineTypeHistory:Array<String>
    ):Option<GetConditionError>
    {
        return switch (constructor)
        {
            case EnumConstructor.Primitive(name):
                Option.Some(argumentName.error(ArgumentSuffixErrorKind.InlineString));
                
            case EnumConstructor.Parameterized(parameterized):
                switch (parameterized.name.kind)
                {
                    case EnumConstructorKind.Normal:
                        condition.conditions.push(LislaToEntityCaseCondition.Const(parameterized.name.name));
                        Option.None;
                        
                    case EnumConstructorKind.Tuple:
                        switch (parameterized.elements.getFirstElementCondition(source, definitionParameters, tupleInlineTypeHistory))
                        {
                            case Result.Ok(tupleCondition):
                                if (tupleCondition.canBeEmpty) condition.canBeEmpty = true;
                                condition.addConditions(tupleCondition.conditions);
                                Option.None;
                                
                            case Result.Error(error):
                                Option.Some(error);
                        }
                        
                    case EnumConstructorKind.Inline:
                        var elements = parameterized.elements;
                        if (elements.length != 1)
                        {
                            Option.Some(error(parameterized.name, EnumConstructorSuffixErrorKind.InvalidInlineEnumConstructorParameterLength(elements.length)));
                        }
                        else
                        {
                            switch (elements[0])
                            {
                                case TupleElement.Argument(argument):
                                    var path = argument.type.getTypePath();
                                    var pathName = path.toString();
                                    if (enumInlineTypeHistory.indexOf(pathName) != -1)
                                    {
                                        Option.Some(error(parameterized.name, EnumConstructorSuffixErrorKind.LoopedInline(path)));
                                    }
                                    else
                                    {
                                        switch (argument.type.follow(source, definitionParameters))
                                        {
                                            case Result.Ok(followedType):
                                                switch followedType.getFirstElementCondition(argument.name, source, definitionParameters, tupleInlineTypeHistory, enumInlineTypeHistory)
                                                {
                                                    case Result.Ok(tupleCondition):
                                                        if (tupleCondition.canBeEmpty) condition.canBeEmpty = true;
                                                        condition.addConditions(tupleCondition.conditions);
                                                        Option.None;
                                                        
                                                    case Result.Error(error):
                                                        Option.Some(error);
                                                }
                                                
                                            case Result.Error(error):
                                                Option.Some(new GetConditionError(GetConditionErrorKind.Follow(error)));
                                        }
                                    }
                                    
                                case TupleElement.Label(_):
                                    Option.Some(error(parameterized.name, EnumConstructorSuffixErrorKind.InvalidInlineEnumConstructorLabel));
                            }
                        }
                }
        }
    }
}

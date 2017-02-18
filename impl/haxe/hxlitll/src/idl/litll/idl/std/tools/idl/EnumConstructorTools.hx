package litll.idl.std.tools.idl;
import haxe.ds.Option;
import litll.core.LitllString;
import hxext.ds.Result;
import litll.idl.generator.output.delitll.match.LitllToEntityCaseCondition;
import litll.idl.generator.output.delitll.match.FirstElementCondition;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.EnumConstructorKind;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.ParameterizedEnumConstructor;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.error.ArgumentSuffixErrorKind;
import litll.idl.std.error.EnumConstructorSuffixError;
import litll.idl.std.error.EnumConstructorSuffixErrorKind;
import litll.idl.std.error.GetConditionErrorKind;

using litll.idl.std.tools.idl.TypeReferenceTools;

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
    
    public static function getConditions(constructor:EnumConstructor, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<Array<LitllToEntityCaseCondition>, GetConditionErrorKind>
    {
        var result = [];
        return switch (_getConditions(constructor, source, definitionParameters, result, []))
        {
            case Option.None:
                Result.Ok(result);
                
            case Option.Some(error):
                Result.Err(error);
        }
    }
       
    public static function _getConditions(
        constructor:EnumConstructor, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        result:Array<LitllToEntityCaseCondition>,
        history:Array<String>
    ):Option<GetConditionErrorKind>
    {
        return switch (constructor)
        {
            case EnumConstructor.Primitive(name):
                result.push(LitllToEntityCaseCondition.Const(name.name));
                Option.None;
                
            case EnumConstructor.Parameterized(parameterized):
                switch (parameterized.name.kind)
                {
                    case EnumConstructorKind.Normal:
                        var label = TupleElement.Label(new LitllString(parameterized.name.name, parameterized.name.tag));
                        switch (TupleTools.getGuard([label].concat(parameterized.elements), source, definitionParameters))
                        {
                            case Result.Ok(data):
                                result.push(LitllToEntityCaseCondition.Arr(data));
                                Option.None;
                                
                            case Result.Err(error):
                                Option.Some(error);
                        }
                        
                    case EnumConstructorKind.Tuple:
                        switch (TupleTools.getGuard(parameterized.elements, source, definitionParameters))
                        {
                            case Result.Ok(data):
                                result.push(LitllToEntityCaseCondition.Arr(data));
                                Option.None;
                                
                            case Result.Err(error):
                                Option.Some(error);
                        }
                        
                    case EnumConstructorKind.Inline:
                        var elements = parameterized.elements;
                        if (elements.length != 1)
                        {
                            Option.Some(errorKind(parameterized.name, EnumConstructorSuffixErrorKind.InvalidInlineEnumConstructorParameterLength(elements.length)));
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
                                        Option.Some(errorKind(parameterized.name, EnumConstructorSuffixErrorKind.LoopedInline(path)));
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
                                                
                                            case Result.Err(error):
                                                Option.Some(GetConditionErrorKind.Follow(error));
                                        }
                                    }
                                    
                                case TupleElement.Label(litllString):
                                    Option.Some(errorKind(parameterized.name, EnumConstructorSuffixErrorKind.InvalidInlineEnumConstructorLabel));
                            }
                        }
                }
        }
    }
    
    private static inline function errorKind(name:EnumConstructorName, kind:EnumConstructorSuffixErrorKind):GetConditionErrorKind
    {
        return GetConditionErrorKind.EnumConstructorSuffix(
            new EnumConstructorSuffixError(name, kind)
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
                        var label = TupleElement.Label(new LitllString(parameterized.name.name, parameterized.name.tag));
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
    ):Option<GetConditionErrorKind>
    {
        return switch (constructor)
        {
            case EnumConstructor.Primitive(name):
                Option.Some(argumentName.errorKind(ArgumentSuffixErrorKind.InlineString));
                
            case EnumConstructor.Parameterized(parameterized):
                switch (parameterized.name.kind)
                {
                    case EnumConstructorKind.Normal:
                        condition.conditions.push(LitllToEntityCaseCondition.Const(parameterized.name.name));
                        Option.None;
                        
                    case EnumConstructorKind.Tuple:
                        switch (parameterized.elements.getFirstElementCondition(source, definitionParameters, tupleInlineTypeHistory))
                        {
                            case Result.Ok(tupleCondition):
                                if (tupleCondition.canBeEmpty) condition.canBeEmpty = true;
                                condition.addConditions(tupleCondition.conditions);
                                Option.None;
                                
                            case Result.Err(error):
                                Option.Some(error);
                        }
                        
                    case EnumConstructorKind.Inline:
                        var elements = parameterized.elements;
                        if (elements.length != 1)
                        {
                            Option.Some(errorKind(parameterized.name, EnumConstructorSuffixErrorKind.InvalidInlineEnumConstructorParameterLength(elements.length)));
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
                                        Option.Some(errorKind(parameterized.name, EnumConstructorSuffixErrorKind.LoopedInline(path)));
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
                                                        
                                                    case Result.Err(error):
                                                        Option.Some(error);
                                                }
                                                
                                            case Result.Err(error):
                                                Option.Some(GetConditionErrorKind.Follow(error));
                                        }
                                    }
                                    
                                case TupleElement.Label(_):
                                    Option.Some(errorKind(parameterized.name, EnumConstructorSuffixErrorKind.InvalidInlineEnumConstructorLabel));
                            }
                        }
                }
        }
    }
}

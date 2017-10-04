package arraytree.idl.std.tools.idl;
import haxe.ds.Option;
import arraytree.data.meta.core.StringWithtag;
import hxext.ds.Result;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityCaseCondition;
import arraytree.idl.generator.output.arraytree2entity.match.FirstElementCondition;
import arraytree.idl.generator.source.IdlSourceProvider;
import arraytree.idl.std.entity.idl.ArgumentName;
import arraytree.idl.std.entity.idl.EnumConstructor;
import arraytree.idl.std.entity.idl.EnumConstructorKind;
import arraytree.idl.std.entity.idl.EnumConstructorName;
import arraytree.idl.std.entity.idl.ParameterizedEnumConstructor;
import arraytree.idl.std.entity.idl.TupleElement;
import arraytree.idl.std.entity.idl.TypeName;
import arraytree.idl.std.entity.idl.TypeReference;
import arraytree.idl.std.error.ArgumentSuffixErrorKind;
import arraytree.idl.std.error.EnumConstructorSuffixError;
import arraytree.idl.std.error.EnumConstructorSuffixErrorKind;
import arraytree.idl.std.error.GetConditionError;
import arraytree.idl.std.error.GetConditionErrorKind;

using arraytree.idl.std.tools.idl.TypeReferenceTools;

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
    ):Result<Array<ArrayTreeToEntityCaseCondition>, GetConditionError>
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
        result:Array<ArrayTreeToEntityCaseCondition>,
        history:Array<String>
    ):Option<GetConditionError>
    {
        return switch (constructor)
        {
            case EnumConstructor.Primitive(name):
                result.push(ArrayTreeToEntityCaseCondition.Const(name.name));
                Option.None;
                
            case EnumConstructor.Parameterized(parameterized):
                switch (parameterized.name.kind)
                {
                    case EnumConstructorKind.Normal:
                        var label = TupleElement.Label(new StringWithtag(parameterized.name.name, parameterized.name.tag));
                        switch (TupleTools.getGuard([label].concat(parameterized.elements), source, definitionParameters))
                        {
                            case Result.Ok(data):
                                result.push(ArrayTreeToEntityCaseCondition.Arr(data));
                                Option.None;
                                
                            case Result.Error(error):
                                Option.Some(error);
                        }
                        
                    case EnumConstructorKind.Tuple:
                        switch (TupleTools.getGuard(parameterized.elements, source, definitionParameters))
                        {
                            case Result.Ok(data):
                                result.push(ArrayTreeToEntityCaseCondition.Arr(data));
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
                                    
                                case TupleElement.Label(arraytreeString):
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
                        var label = TupleElement.Label(new StringWithtag(parameterized.name.name, parameterized.name.tag));
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
                        condition.conditions.push(ArrayTreeToEntityCaseCondition.Const(parameterized.name.name));
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

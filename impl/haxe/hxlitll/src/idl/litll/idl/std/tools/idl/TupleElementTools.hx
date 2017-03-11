package lisla.idl.std.tools.idl;
import haxe.ds.Option;
import hxext.ds.Result;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityCaseCondition;
import lisla.idl.generator.output.lisla2entity.match.FirstElementCondition;
import lisla.idl.generator.source.IdlSourceProvider;
import lisla.idl.std.entity.idl.ArgumentKind;
import lisla.idl.std.entity.idl.TupleElement;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.entity.idl.TypeReference;
import lisla.idl.std.error.ArgumentSuffixErrorKind;
import lisla.idl.std.error.GetConditionErrorKind;

class TupleElementTools
{
    public static function mapOverTypeReference(element:TupleElement, func:TypeReference->TypeReference):TupleElement
    {
        return switch (element)
        {
            case TupleElement.Label(_):
                element;
                
            case TupleElement.Argument(argument):
                TupleElement.Argument(ArgumentTools.mapOverTypeReference(argument, func));
        }
    }
    
    public static function iterateOverTypeReference(element:TupleElement, func:TypeReference-> Void):Void
    {
        switch (element)
        {
            case TupleElement.Label(_):
                // nothing to do
                
            case TupleElement.Argument(argument):
                func(argument.type);
        }
    }
    
    
    public static function applyFirstElementCondition(
        element:TupleElement,
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        condition:FirstElementCondition, 
        history:Array<String>
    ):Option<GetConditionErrorKind>
    {
        if (!condition.canBeEmpty) return Option.None;
        
        return switch (element)
        {
            case TupleElement.Label(value):
                condition.canBeEmpty = false;
                condition.conditions.push(LislaToEntityCaseCondition.Const(value.data));
                Option.None;
                
            case TupleElement.Argument(argument):
                switch [argument.name.kind, argument.defaultValue]
                {
                    case [ArgumentKind.Normal, Option.None]:
                        condition.canBeEmpty = false;
                        switch (argument.type.getConditions(source, definitionParameters))
                        {
                            case Result.Ok(conditions):
                                condition.addConditions(conditions);
                                Option.None;
                                
                            case Result.Err(error):
                                Option.Some(error);
                        }
                        
                    case [ArgumentKind.Optional, Option.None] 
                        | [ArgumentKind.Normal, Option.Some(_)]
                        | [ArgumentKind.Rest, Option.None]:
                        switch (argument.type.getConditions(source, definitionParameters))
                        {
                            case Result.Ok(conditions):
                                condition.addConditions(conditions);
                                Option.None;
                                
                            case Result.Err(error):
                                Option.Some(error);
                        }
                        
                    case [ArgumentKind.RestInline, Option.None]
                        | [ArgumentKind.OptionalInline, Option.None]:
                        var typePath = argument.type.getTypePath().toString();
                        switch (argument.type.follow(source, definitionParameters))
                        {
                            case Result.Ok(followedType):
                                switch (followedType.getNotEmptyFirstElementCondition(argument.name, source, definitionParameters, history.concat([typePath]), []))
                                {
                                    case Result.Ok(conditions):
                                        condition.addConditions(conditions);
                                        Option.None;
                                    
                                    case Result.Err(error):
                                        Option.Some(error);
                                }
                                
                            case Result.Err(error):
                                Option.Some(GetConditionErrorKind.Follow(error));
                        }
                            
                    case [ArgumentKind.Inline, Option.None]:
                        var typePath = argument.type.getTypePath().toString();
                        switch (argument.type.follow(source, definitionParameters))
                        {
                            case Result.Ok(followedType):
                                switch (followedType.getFirstElementCondition(argument.name, source, definitionParameters, history.concat([typePath]), []))
                                {
                                    case Result.Ok(childCondition):
                                        condition.canBeEmpty = childCondition.canBeEmpty;
                                        condition.addConditions(childCondition.conditions);
                                        Option.None;
                                    
                                    case Result.Err(error):
                                        Option.Some(error);
                                }
                                
                            case Result.Err(error):
                                Option.Some(GetConditionErrorKind.Follow(error));
                        }
                        
                    case [ArgumentKind.Rest, Option.Some(_)] 
                        | [ArgumentKind.Inline, Option.Some(_)]
                        | [ArgumentKind.Optional, Option.Some(_)]
                        | [ArgumentKind.OptionalInline, Option.Some(_)]
                        | [ArgumentKind.RestInline, Option.Some(_)]:
                        Option.Some(argument.name.errorKind(ArgumentSuffixErrorKind.UnsupportedDefault(argument.name.kind)));
                }
        }
    }
}

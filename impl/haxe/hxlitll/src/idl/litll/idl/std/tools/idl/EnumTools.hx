package litll.idl.std.tools.idl;
import haxe.ds.Option;
import litll.core.ds.Result;
import litll.idl.generator.output.delitll.match.LitllToBackendCaseCondition;
import litll.idl.generator.output.delitll.match.LitllToBackendGuardConditionKind;
import litll.idl.generator.output.delitll.match.LitllToBackendGuardConditionKindTools;
import litll.idl.generator.output.delitll.match.FirstElementCondition;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.EnumConstructorKind;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.error.EnumConstructorSuffixError;
import litll.idl.std.error.EnumConstructorSuffixErrorKind;
import litll.idl.std.error.GetConditionErrorKind;

class EnumTools 
{
    private static inline function errorKind(name:EnumConstructorName, kind:EnumConstructorSuffixErrorKind):GetConditionErrorKind
    {
        return GetConditionErrorKind.EnumConstructorSuffix(
            new EnumConstructorSuffixError(name, kind)
        );
    }
    
    public static function getGuardConditionKind(constructors:Array<EnumConstructor>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<LitllToBackendGuardConditionKind, GetConditionErrorKind>
    {
        var kind1 = LitllToBackendGuardConditionKind.Never;
        inline function error(name:EnumConstructorName, kind:EnumConstructorSuffixErrorKind):Result<LitllToBackendGuardConditionKind, GetConditionErrorKind>
        {
            return Result.Err(errorKind(name, kind));
        }
        
        for (constructor in constructors)
        {
            var kind2 = switch (constructor)
            {
                case EnumConstructor.Primitive(name):
                    switch (name.kind)
                    {
                        case EnumConstructorKind.Normal:
                            LitllToBackendGuardConditionKind.Const([name.name => true]);
                    
                        case EnumConstructorKind.Tuple:
                            return error(name, EnumConstructorSuffixErrorKind.TupleSuffixForPrimitiveEnumConstructor);
                            
                        case EnumConstructorKind.Inline:
                            return error(name, EnumConstructorSuffixErrorKind.InlineSuffixForPrimitiveEnumConstructor);
                    }
                    
                case EnumConstructor.Parameterized(parameterized):
                    switch (parameterized.name.kind)
                    {
                        case EnumConstructorKind.Normal | EnumConstructorKind.Tuple:
                            LitllToBackendGuardConditionKind.Arr;
                    
                        case EnumConstructorKind.Inline:
                            var elements = parameterized.elements;
                            if (elements.length != 1)
                            {
                                return error(parameterized.name, EnumConstructorSuffixErrorKind.InvalidInlineEnumConstructorParameterLength(elements.length));
                            }
                            
                            switch (elements[0])
                            {
                                case TupleElement.Argument(argument):
                                    switch (TypeReferenceTools.getGuardConditionKind(argument.type, source, definitionParameters))
                                    {
                                        case Result.Ok(data):
                                            data;
                                            
                                        case Result.Err(error):
                                            return Result.Err(error);
                                    }
                                    
                                case TupleElement.Label(litllString):
                                    LitllToBackendGuardConditionKind.Const([litllString.data => true]);
                            }
                    }
            }
            
            kind1 = LitllToBackendGuardConditionKindTools.merge(kind1, kind2);
        }
        
        return Result.Ok(kind1);
    }
    
    public static function getFirstElementCondition(
        constructors:Array<EnumConstructor>,
        argumentName:ArgumentName, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        tupleInlineTypeHistory:Array<String>,
        enumInlineTypeHistory:Array<String>
    ):Result<FirstElementCondition, GetConditionErrorKind>
    {
        var condition = new FirstElementCondition(false, []);
        return switch (
            applyFirstElementCondition(
                constructors, 
                argumentName, 
                source, 
                definitionParameters, 
                condition, 
                tupleInlineTypeHistory, 
                enumInlineTypeHistory
            )
        )
        {
            case Option.None:
                Result.Ok(condition);
                
            case Option.Some(error):
                Result.Err(error);
        }
    }
    
    public static function applyFirstElementCondition(
        constructors:Array<EnumConstructor>,
        argumentName:ArgumentName,  
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        condition:FirstElementCondition, 
        tupleInlineTypeHistory:Array<String>,
        enumInlineTypeHistory:Array<String>
    ):Option<GetConditionErrorKind>
    {
        for (constructor in constructors)
        {
            switch (
                constructor.applyFirstElementCondition(
                    argumentName, 
                    source, 
                    definitionParameters, 
                    condition, 
                    tupleInlineTypeHistory, 
                    enumInlineTypeHistory
                )
            )
            {
                case Option.None:
                    // continue
                    
                case Option.Some(error):
                    return Option.Some(error);
            }
        }
        
        return Option.None;
    }
}

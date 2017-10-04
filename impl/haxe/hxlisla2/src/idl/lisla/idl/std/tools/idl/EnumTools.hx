package arraytree.idl.std.tools.idl;
import haxe.ds.Option;
import hxext.ds.Result;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityCaseCondition;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityGuardConditionKind;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityGuardConditionKindTools;
import arraytree.idl.generator.output.arraytree2entity.match.FirstElementCondition;
import arraytree.idl.generator.source.IdlSourceProvider;
import arraytree.idl.std.entity.idl.ArgumentName;
import arraytree.idl.std.entity.idl.EnumConstructor;
import arraytree.idl.std.entity.idl.EnumConstructorKind;
import arraytree.idl.std.entity.idl.EnumConstructorName;
import arraytree.idl.std.entity.idl.TupleElement;
import arraytree.idl.std.entity.idl.TypeName;
import arraytree.idl.std.error.EnumConstructorSuffixError;
import arraytree.idl.std.error.EnumConstructorSuffixErrorKind;
import arraytree.idl.std.error.GetConditionError;
import arraytree.idl.std.error.GetConditionErrorKind;

class EnumTools 
{
    private static inline function error(name:EnumConstructorName, kind:EnumConstructorSuffixErrorKind):GetConditionError
    {
        return new GetConditionError(
            GetConditionErrorKind.EnumConstructorSuffix(
                new EnumConstructorSuffixError(name, kind)
            )
        );
    }
    
    public static function getGuardConditionKind(constructors:Array<EnumConstructor>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<ArrayTreeToEntityGuardConditionKind, GetConditionError>
    {
        var kind1 = ArrayTreeToEntityGuardConditionKind.Never;
        inline function errorResult(name:EnumConstructorName, kind:EnumConstructorSuffixErrorKind):Result<ArrayTreeToEntityGuardConditionKind, GetConditionError>
        {
            return Result.Error(error(name, kind));
        }
        
        for (constructor in constructors)
        {
            var kind2 = switch (constructor)
            {
                case EnumConstructor.Primitive(name):
                    switch (name.kind)
                    {
                        case EnumConstructorKind.Normal:
                            ArrayTreeToEntityGuardConditionKind.Const([name.name => true]);
                    
                        case EnumConstructorKind.Tuple:
                            return errorResult(name, EnumConstructorSuffixErrorKind.TupleSuffixForPrimitiveEnumConstructor);
                            
                        case EnumConstructorKind.Inline:
                            return errorResult(name, EnumConstructorSuffixErrorKind.InlineSuffixForPrimitiveEnumConstructor);
                    }
                    
                case EnumConstructor.Parameterized(parameterized):
                    switch (parameterized.name.kind)
                    {
                        case EnumConstructorKind.Normal | EnumConstructorKind.Tuple:
                            ArrayTreeToEntityGuardConditionKind.Arr;
                    
                        case EnumConstructorKind.Inline:
                            var elements = parameterized.elements;
                            if (elements.length != 1)
                            {
                                return errorResult(parameterized.name, EnumConstructorSuffixErrorKind.InvalidInlineEnumConstructorParameterLength(elements.length));
                            }
                            
                            switch (elements[0])
                            {
                                case TupleElement.Argument(argument):
                                    switch (TypeReferenceTools.getGuardConditionKind(argument.type, source, definitionParameters))
                                    {
                                        case Result.Ok(data):
                                            data;
                                            
                                        case Result.Error(error):
                                            return Result.Error(error);
                                    }
                                    
                                case TupleElement.Label(arraytreeString):
                                    ArrayTreeToEntityGuardConditionKind.Const([arraytreeString.data => true]);
                            }
                    }
            }
            
            kind1 = ArrayTreeToEntityGuardConditionKindTools.merge(kind1, kind2);
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
    ):Result<FirstElementCondition, GetConditionError>
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
                Result.Error(error);
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
    ):Option<GetConditionError>
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

package litll.idl.std.tools.idl;
import litll.core.ds.Result;
import litll.idl.generator.output.delitll.match.DelitllfyGuardConditionKind;
import litll.idl.generator.output.delitll.match.DelitllfyGuardConditionKindTools;
import litll.idl.generator.source.IdlSourceProvider;
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
    
    public static function getGuardConditionKind(constructors:Array<EnumConstructor>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<DelitllfyGuardConditionKind, GetConditionErrorKind>
    {
        var kind1 = DelitllfyGuardConditionKind.Never;
        inline function error(name:EnumConstructorName, kind:EnumConstructorSuffixErrorKind):Result<DelitllfyGuardConditionKind, GetConditionErrorKind>
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
                            DelitllfyGuardConditionKind.Const([name.name => true]);
                    
                        case EnumConstructorKind.Tuple:
                            return error(name, EnumConstructorSuffixErrorKind.TupleSuffixForPrimitiveEnumConstructor);
                            
                        case EnumConstructorKind.Inline:
                            return error(name, EnumConstructorSuffixErrorKind.InlineSuffixForPrimitiveEnumConstructor);
                    }
                    
                case EnumConstructor.Parameterized(parameterized):
                    switch (parameterized.name.kind)
                    {
                        case EnumConstructorKind.Normal | EnumConstructorKind.Tuple:
                            DelitllfyGuardConditionKind.Arr;
                    
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
                                    DelitllfyGuardConditionKind.Const([litllString.data => true]);
                            }
                    }
            }
            
            kind1 = DelitllfyGuardConditionKindTools.merge(kind1, kind2);
        }
        
        return Result.Ok(kind1);
    }   
}
package lisla.idl.generator.error;
import lisla.idl.std.entity.idl.EnumConstructorName;

enum EnumConstructorValidationErrorKind 
{
    NameDuplicated(name1:EnumConstructorName);
    ConditionDuplicated(name1:EnumConstructorName);
}
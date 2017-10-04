package arraytree.idl.generator.error;
import arraytree.idl.std.entity.idl.EnumConstructorName;

enum EnumConstructorValidationErrorKind 
{
    NameDuplicated(name1:EnumConstructorName);
    ConditionDuplicated(name1:EnumConstructorName);
}
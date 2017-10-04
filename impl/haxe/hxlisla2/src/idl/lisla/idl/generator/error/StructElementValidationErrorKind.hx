package arraytree.idl.generator.error;
import arraytree.idl.std.entity.idl.StructElementName;

enum StructElementValidationErrorKind 
{
    NameDuplicated(existingName:StructElementName);
    ConditionDuplicated(existingName:StructElementName);    
}

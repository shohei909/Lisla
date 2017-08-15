package lisla.idl.generator.error;
import lisla.idl.std.entity.idl.StructElementName;

enum StructElementValidationErrorKind 
{
    NameDuplicated(existingName:StructElementName);
    ConditionDuplicated(existingName:StructElementName);    
}

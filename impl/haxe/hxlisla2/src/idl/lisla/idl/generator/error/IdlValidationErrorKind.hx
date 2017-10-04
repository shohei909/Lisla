package arraytree.idl.generator.error;
import arraytree.idl.std.entity.idl.ArgumentName;
import arraytree.idl.std.entity.idl.EnumConstructorName;
import arraytree.idl.std.entity.idl.StructElementName;
import arraytree.idl.std.entity.idl.TypeDependenceName;
import arraytree.idl.std.error.GetConditionError;

enum IdlValidationErrorKind 
{
    GetCondition(error:GetConditionError);
    StructElement(error:StructElementValidationError);
    EnumConstuctor(error:EnumConstructorValidationError);
    TypeDependence(name:TypeDependenceValidationError);
    Argument(name:ArgumentValidationError);
}

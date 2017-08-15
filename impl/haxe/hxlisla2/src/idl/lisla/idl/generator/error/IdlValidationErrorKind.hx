package lisla.idl.generator.error;
import lisla.idl.std.entity.idl.ArgumentName;
import lisla.idl.std.entity.idl.EnumConstructorName;
import lisla.idl.std.entity.idl.StructElementName;
import lisla.idl.std.entity.idl.TypeDependenceName;
import lisla.idl.std.error.GetConditionError;

enum IdlValidationErrorKind 
{
    GetCondition(error:GetConditionError);
    StructElement(error:StructElementValidationError);
    EnumConstuctor(error:EnumConstructorValidationError);
    TypeDependence(name:TypeDependenceValidationError);
    Argument(name:ArgumentValidationError);
}

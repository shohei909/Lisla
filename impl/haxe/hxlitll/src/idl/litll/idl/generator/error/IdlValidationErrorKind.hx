package lisla.idl.generator.error;
import lisla.idl.std.entity.idl.ArgumentName;
import lisla.idl.std.entity.idl.EnumConstructorName;
import lisla.idl.std.entity.idl.StructElementName;
import lisla.idl.std.entity.idl.TypeDependenceName;
import lisla.idl.std.error.GetConditionErrorKind;
import lisla.idl.std.error.TypeFollowErrorKind;

enum IdlValidationErrorKind 
{
    GetCondition(error:GetConditionErrorKind);
    
	TypeDependenceNameDuplicated(name:TypeDependenceName);
	ArgumentNameDuplicated(name:ArgumentName);
    EnumConstuctorNameDuplicated(name0:EnumConstructorName, name1:EnumConstructorName);
    EnumConstuctorConditionDuplicated(name0:EnumConstructorName, name1:EnumConstructorName);
    
    StructElementNameDuplicated(name0:StructElementName, name1:StructElementName);
    StructElementConditionDuplicated(name0:StructElementName, name1:StructElementName);
}

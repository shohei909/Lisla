package litll.idl.generator.error;
import litll.idl.std.entity.idl.ArgumentName;
import litll.idl.std.entity.idl.EnumConstructorName;
import litll.idl.std.entity.idl.StructElementName;
import litll.idl.std.entity.idl.TypeDependenceName;
import litll.idl.std.error.GetConditionErrorKind;
import litll.idl.std.error.TypeFollowErrorKind;

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

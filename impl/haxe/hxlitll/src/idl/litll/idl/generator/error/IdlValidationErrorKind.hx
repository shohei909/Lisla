package litll.idl.generator.error;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.StructFieldName;
import litll.idl.std.data.idl.TypeDependenceName;
import litll.idl.std.error.GetConditionErrorKind;
import litll.idl.std.error.TypeFollowErrorKind;

enum IdlValidationErrorKind 
{
    GetCondition(error:GetConditionErrorKind);
    
	TypeDependenceNameDuplicated(name:TypeDependenceName);
	ArgumentNameDuplicated(name:ArgumentName);
    StructFieldNameDuplicated(name:StructFieldName);
    EnumConstuctorNameDuplicated(name:EnumConstructorName);
    EnumConstuctorConditionDuplicated(name0:EnumConstructorName, name1:EnumConstructorName);
}

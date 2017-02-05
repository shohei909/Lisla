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
    
	TypeDependenceNameDupplicated(name:TypeDependenceName);
	ArgumentNameDupplicated(name:ArgumentName);
    StructFieldNameDupplicated(name:StructFieldName);
    EnumConstuctorNameDupplicated(name:EnumConstructorName);
}

package litll.idl.generator.source;
import hxext.ds.Maybe;
import litll.idl.generator.source.file.IdlFilePath;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypeName;

enum ModuleState 
{
	Unloaded;
	Empty;
	Loading(typeNames:Map<String, TypeDefinition>, file:IdlFilePath);
	Loaded(typeNames:Map<String, TypeDefinition>, file:IdlFilePath);
	Validating(typeNames:Map<String, TypeDefinition>, file:IdlFilePath);
    Validated(typeNames:Map<String, ValidType>);
}

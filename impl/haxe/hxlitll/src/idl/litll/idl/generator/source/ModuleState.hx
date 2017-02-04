package litll.idl.generator.source;
import litll.core.ds.Maybe;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypeName;

enum ModuleState 
{
	Unloaded;
	Empty;
	Loading(typeNames:Map<String, TypeDefinition>);
	Loaded(typeNames:Map<String, TypeDefinition>);
	Validating(typeNames:Map<String, TypeDefinition>);
    Validated(typeNames:Map<String, ValidType>);
}

package litll.idl.project.source;
import litll.core.ds.Maybe;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypeName;

enum ModuleState 
{
	Unloaded;
	Loading(typeNames:Map<String, TypeDefinition>);
	Loaded(typeNames:Maybe<Map<String, TypeDefinition>>);
}

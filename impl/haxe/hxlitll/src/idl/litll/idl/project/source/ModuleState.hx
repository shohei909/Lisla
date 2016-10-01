package litll.idl.project.source;
import haxe.ds.Option;
import litll.core.ds.Set;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeDefinition;

enum ModuleState 
{
	Unloaded;
	Loading(typeNames:Map<TypeName, TypeDefinition>);
	Loaded(typeNames:Option<Map<TypeName, TypeDefinition>>);
}

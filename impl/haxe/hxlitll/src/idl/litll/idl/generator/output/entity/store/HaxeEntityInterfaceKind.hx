package litll.idl.generator.output.entity.store;

enum HaxeEntityInterfaceKind
{
	Enum(data:litll.idl.generator.output.entity.store.HaxeEntityEnumInterface);
	Class(data:litll.idl.generator.output.entity.store.HaxeEntityClassInterface);
}
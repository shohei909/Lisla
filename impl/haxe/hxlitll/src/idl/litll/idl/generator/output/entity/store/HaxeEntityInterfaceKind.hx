package lisla.idl.generator.output.entity.store;

enum HaxeEntityInterfaceKind
{
	Enum(data:lisla.idl.generator.output.entity.store.HaxeEntityEnumInterface);
	Class(data:lisla.idl.generator.output.entity.store.HaxeEntityClassInterface);
}
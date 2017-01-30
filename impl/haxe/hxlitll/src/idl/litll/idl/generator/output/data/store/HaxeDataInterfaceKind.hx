package litll.idl.generator.output.data.store;

enum HaxeDataInterfaceKind
{
	Enum(data:litll.idl.generator.output.data.store.HaxeDataEnumInterface);
	Class(data:litll.idl.generator.output.data.store.HaxeDataClassInterface);
}
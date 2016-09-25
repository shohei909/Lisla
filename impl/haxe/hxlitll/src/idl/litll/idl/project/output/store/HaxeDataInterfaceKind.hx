package litll.idl.project.output.store;

enum HaxeDataInterfaceKind
{
	Enum(data:litll.idl.project.output.store.HaxeDataEnumInterface);
	Class(data:litll.idl.project.output.store.HaxeDataClassInterface);
}
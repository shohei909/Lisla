package litll.idl.project.output.data.store;

enum HaxeDataInterfaceKind
{
	Enum(data:litll.idl.project.output.data.store.HaxeDataEnumInterface);
	Class(data:litll.idl.project.output.data.store.HaxeDataClassInterface);
}
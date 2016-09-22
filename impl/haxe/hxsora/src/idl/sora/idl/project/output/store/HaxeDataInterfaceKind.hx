package sora.idl.project.output.store;

enum HaxeDataInterfaceKind
{
	Enum(data:sora.idl.project.output.store.HaxeDataEnumInterface);
	Class(data:sora.idl.project.output.store.HaxeDataClassInterface);
}
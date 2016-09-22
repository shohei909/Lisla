package sora.idl.project.output;
import sora.idl.project.output.store.HaxeDataInterfaceStore;
import sora.idl.project.source.IdlSourceProvider;
import sora.idl.std.data.idl.project.DataOutputConfig;

interface IdlToHaxeConvertContext
{
	public var source(default, null):IdlSourceProvider;
	public var dataOutputConfig(default, null):DataOutputConfig;
	public var interfaceStore(default, null):HaxeDataInterfaceStore;
}
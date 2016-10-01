package litll.idl.project.output;
import litll.idl.project.output.store.HaxeDataInterfaceStore;
import litll.idl.project.source.IdlSourceProvider;
import litll.idl.std.data.idl.haxe.DataOutputConfig;

interface IdlToHaxeConvertContext
{
	public var source(default, null):IdlSourceProvider;
	public var dataOutputConfig(default, null):DataOutputConfig;
	public var interfaceStore(default, null):HaxeDataInterfaceStore;
}
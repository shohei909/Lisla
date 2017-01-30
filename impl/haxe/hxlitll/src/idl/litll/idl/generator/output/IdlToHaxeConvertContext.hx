package litll.idl.generator.output;
import litll.idl.generator.output.data.store.HaxeDataConstructorKind;
import litll.idl.generator.output.data.store.HaxeDataClassInterface;
import litll.idl.generator.output.data.store.HaxeDataInterfaceStore;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.GenericTypeReference;
import litll.idl.generator.data.DataOutputConfig;
import litll.idl.generator.data.DelitllfierOutputConfig;

interface IdlToHaxeConvertContext
{
	public var source(default, null):IdlSourceProvider;
	public var dataOutputConfig(default, null):DataOutputConfig;
	public var interfaceStore(default, null):HaxeDataInterfaceStore;
}
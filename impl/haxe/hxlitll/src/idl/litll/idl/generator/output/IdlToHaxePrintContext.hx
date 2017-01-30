package litll.idl.generator.output;
import litll.core.ds.Maybe;
import litll.idl.generator.io.IoProvider;
import litll.idl.generator.io.StandardIoProvider;
import litll.idl.generator.output.data.store.HaxeDataInterfaceStore;
import litll.idl.generator.output.haxe.HaxePrinter;
import litll.idl.generator.output.haxe.HaxePrinterImpl;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.generator.source.IdlSourceProviderImpl;
import litll.idl.generator.data.DataOutputConfig;
import litll.idl.generator.data.DelitllfierOutputConfig;
import litll.idl.generator.data.ProjectConfig;

class IdlToHaxePrintContext implements IdlToHaxeConvertContext
{
	public var io(default, null):IoProvider;
	public var printer(default, null):HaxePrinter;
	
	public var source(default, null):IdlSourceProvider;
	public var dataOutputConfig(default, null):DataOutputConfig;
	public var interfaceStore(default, null):HaxeDataInterfaceStore;
	
	public var delitllfierOutputConfig(default, null):Maybe<DelitllfierOutputConfig>;
	
	public function new(
		source:IdlSourceProvider,
		io:IoProvider,
		printer:HaxePrinter,
		dataOutputConfig:DataOutputConfig,
		delitllfierOutputConfig:Maybe<DelitllfierOutputConfig>
	)
	{
		this.delitllfierOutputConfig = delitllfierOutputConfig;
		this.dataOutputConfig = dataOutputConfig;
		this.io = io;
		this.printer = printer;
		this.source = source;
		this.interfaceStore = new litll.idl.generator.output.data.store.HaxeDataInterfaceStore();
	}
	
	public static function createDefault(homeDirectory:String, config:ProjectConfig):IdlToHaxePrintContext
	{
		var io = new StandardIoProvider();
		
		return new IdlToHaxePrintContext(
			new IdlSourceProviderImpl(homeDirectory, config.sourceConfig),
			io,
			new HaxePrinterImpl(io, config.outputConfig),
			config.outputConfig.dataOutputConfig,
			config.outputConfig.delitllfierOutputConfig
		);
	}
}

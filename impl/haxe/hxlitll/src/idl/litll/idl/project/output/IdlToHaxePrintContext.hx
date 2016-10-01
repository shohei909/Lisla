package litll.idl.project.output;
import haxe.ds.Option;
import litll.idl.project.io.IoProvider;
import litll.idl.project.io.StandardIoProvider;
import litll.idl.project.output.haxe.HaxePrinter;
import litll.idl.project.output.haxe.HaxePrinterImpl;
import litll.idl.project.output.store.HaxeDataInterfaceStore;
import litll.idl.project.source.IdlSourceProvider;
import litll.idl.project.source.IdlSourceProviderImpl;
import litll.idl.std.data.idl.haxe.DataOutputConfig;
import litll.idl.std.data.idl.haxe.DelitllfierOutputConfig;
import litll.idl.std.data.idl.haxe.OutputConfig;
import litll.idl.std.data.idl.haxe.ProjectConfig;

class IdlToHaxePrintContext implements IdlToHaxeConvertContext
{
	public var io(default, null):IoProvider;
	public var printer(default, null):HaxePrinter;
	
	public var source(default, null):IdlSourceProvider;
	public var dataOutputConfig(default, null):DataOutputConfig;
	public var interfaceStore(default, null):HaxeDataInterfaceStore;
	
	public var delitllfierOutputConfig(default, null):Option<DelitllfierOutputConfig>;
	
	public function new(
		source:IdlSourceProvider,
		io:IoProvider,
		printer:HaxePrinter,
		dataOutputConfig:DataOutputConfig,
		delitllfierOutputConfig:Option<DelitllfierOutputConfig>
	)
	{
		this.delitllfierOutputConfig = delitllfierOutputConfig;
		this.dataOutputConfig = dataOutputConfig;
		this.io = io;
		this.printer = printer;
		this.source = source;
		this.interfaceStore = new litll.idl.project.output.store.HaxeDataInterfaceStore();
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

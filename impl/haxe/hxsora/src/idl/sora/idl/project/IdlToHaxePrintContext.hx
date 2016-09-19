package sora.idl.project;
import haxe.ds.Option;
import sora.idl.project.io.IoProvider;
import sora.idl.project.io.StandardIoProvider;
import sora.idl.project.output.HaxePrinter;
import sora.idl.project.output.HaxePrinterImpl;
import sora.idl.project.output.record.HaxeDataInterfaceRecord;
import sora.idl.project.source.IdlSourceProvider;
import sora.idl.project.source.IdlSourceProviderImpl;
import sora.idl.std.data.idl.project.DataOutputConfig;
import sora.idl.std.data.idl.project.DesoralizerOutputConfig;
import sora.idl.std.data.idl.project.OutputConfig;
import sora.idl.std.data.idl.project.ProjectConfig;

class IdlToHaxePrintContext
{ 
	public var source(default, null):IdlSourceProvider;
	public var io(default, null):IoProvider;
	public var printer(default, null):HaxePrinter;
	public var dataOutputConfig(default, null):DataOutputConfig;
	public var desoralizerOutputConfig(default, null):Option<DesoralizerOutputConfig>;
	public var interfaceRecord:HaxeDataInterfaceRecord;

	public function new(
		source:IdlSourceProvider,
		io:IoProvider,
		printer:HaxePrinter,
		dataOutputConfig:DataOutputConfig,
		desoralizerOutputConfig:Option<DesoralizerOutputConfig>
	)
	{
		this.desoralizerOutputConfig = desoralizerOutputConfig;
		this.dataOutputConfig = dataOutputConfig;
		this.io = io;
		this.printer = printer;
		this.source = source;
		this.interfaceRecord = new HaxeDataInterfaceRecord();
	}
	
	public static function createDefault(homeDirectory:String, config:ProjectConfig):IdlToHaxePrintContext
	{
		var io = new StandardIoProvider();
		
		return new IdlToHaxePrintContext(
			new IdlSourceProviderImpl(homeDirectory, config.sourceConfig),
			io,
			new HaxePrinterImpl(io, config.outputConfig),
			config.outputConfig.dataOutputConfig,
			config.outputConfig.desoralizerOutputConfig
		);
	}
}

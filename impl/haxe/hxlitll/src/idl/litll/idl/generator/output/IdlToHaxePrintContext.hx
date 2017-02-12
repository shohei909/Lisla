package litll.idl.generator.output;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.idl.generator.data.DataOutputConfig;
import litll.idl.generator.data.LitllToBackendOutputConfig;
import litll.idl.generator.data.ProjectConfig;
import litll.idl.generator.error.IdlReadError;
import litll.idl.generator.io.IoProvider;
import litll.idl.generator.io.StandardIoProvider;
import litll.idl.generator.output.DataTypeInfomation;
import litll.idl.generator.output.data.store.HaxeDataInterface;
import litll.idl.generator.output.data.store.HaxeDataInterfaceKindTools;
import litll.idl.generator.output.haxe.HaxePrinter;
import litll.idl.generator.output.haxe.HaxePrinterImpl;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.generator.source.RootPackageElement;
import litll.idl.std.data.idl.group.TypeGroupPath;

class IdlToHaxePrintContext implements IdlToHaxeConvertContext
{
	public var source(default, null):IdlSourceProvider;
    
    public var io(default, null):IoProvider;
	public var printer(default, null):HaxePrinter;
	public var dataOutputConfig(default, null):DataOutputConfig;
	public var litllToBackendOutputConfig(default, null):Maybe<LitllToBackendOutputConfig>;
	
	public function new(
		source:IdlSourceProvider,
		io:IoProvider,
		printer:HaxePrinter,
		dataOutputConfig:DataOutputConfig,
		litllToBackendOutputConfig:Maybe<LitllToBackendOutputConfig>
	)
	{
		this.litllToBackendOutputConfig = litllToBackendOutputConfig;
		this.dataOutputConfig = dataOutputConfig;
		this.io = io;
		this.printer = printer;
		this.source = source;
	}
	
	public static function createDefault(homeDirectory:String, config:ProjectConfig):IdlToHaxePrintContext
	{
		var io = new StandardIoProvider();
		
		return new IdlToHaxePrintContext(
			RootPackageElement.create(homeDirectory, config.sourceConfig),
			io,
			new HaxePrinterImpl(io, config.outputConfig),
			config.outputConfig.dataOutputConfig,
			config.outputConfig.litllToBackendOutputConfig
		);
	}
    
    public function resolveGroups(targets:Array<TypeGroupPath>):Result<Array<DataTypeInfomation>, Array<IdlReadError>>
    {
        return switch (source.resolveGroups(targets))
        {
            case Result.Ok(readData):
                var result = [];
                for (type in readData)
                {
                    var haxePath = dataOutputConfig.toHaxeDataPath(type.typePath);
                    var interf = if (dataOutputConfig.predefinedTypes.exists(haxePath.toString()))
                    {
                        dataOutputConfig.predefinedTypes[haxePath.toString()];
                    }
                    else
                    {
                        var kind = HaxeDataInterfaceKindTools.createDefault(type.definition);
                        new HaxeDataInterface(haxePath, kind);
                    }
                    
                    result.push(
                        new DataTypeInfomation(
                            type, interf
                        )
                    );
                }
                
                Result.Ok(result);
                
            case Result.Err(err):
                Result.Err(err);
        }
    }
}

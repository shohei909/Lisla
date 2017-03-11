package litll.idl.generator.output;
import hxext.ds.Maybe;
import hxext.ds.Result;
import litll.idl.generator.data.EntityOutputConfig;
import litll.idl.generator.data.LitllToEntityOutputConfig;
import litll.idl.generator.data.ProjectConfig;
import litll.idl.generator.error.ReadIdlError;
import litll.idl.generator.io.IoProvider;
import litll.idl.generator.io.StandardIoProvider;
import litll.idl.generator.output.EntityTypeInfomation;
import litll.idl.generator.output.entity.store.HaxeEntityInterface;
import litll.idl.generator.output.entity.store.HaxeEntityInterfaceKindTools;
import litll.idl.generator.output.haxe.HaxePrinter;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.library.RootPackageElement;
import litll.idl.std.data.idl.group.TypeGroupPath;

class IdlToHaxePrintContext implements IdlToHaxeConvertContext
{
	public var source(default, null):IdlSourceProvider;
    
    public var io(default, null):IoProvider;
	public var printer(default, null):HaxePrinter;
	public var dataOutputConfig(default, null):EntityOutputConfig;
	public var litllToEntityOutputConfig(default, null):Maybe<LitllToEntityOutputConfig>;
	
	public function new(
		source:IdlSourceProvider,
		io:IoProvider,
		printer:HaxePrinter,
		dataOutputConfig:EntityOutputConfig,
		litllToEntityOutputConfig:Maybe<LitllToEntityOutputConfig>
	)
	{
		this.litllToEntityOutputConfig = litllToEntityOutputConfig;
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
			new HaxePrinter(config.printConfig),
			config.outputConfig.dataOutputConfig,
			config.outputConfig.litllToEntityOutputConfig
		);
	}
    
    public function resolveGroups(targets:Array<TypeGroupPath>):Result<Array<EntityTypeInfomation>, Array<ReadIdlError>>
    {
        return switch (source.resolveGroups(targets))
        {
            case Result.Ok(readData):
                var result = [];
                for (type in readData)
                {
                    var haxePath = dataOutputConfig.toHaxePath(type.typePath);
                    var interf = if (dataOutputConfig.predefinedTypes.exists(haxePath.toString()))
                    {
                        dataOutputConfig.predefinedTypes[haxePath.toString()];
                    }
                    else
                    {
                        var kind = HaxeEntityInterfaceKindTools.createDefault(type.definition);
                        new HaxeEntityInterface(haxePath, kind);
                    }
                    
                    result.push(
                        new EntityTypeInfomation(
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

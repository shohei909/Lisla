package litll.idl.generator.output.delitll.path;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.generator.output.delitll.path.HaxeDelitllfierTypePath;
import litll.idl.std.data.idl.TypePath;
import litll.idl.generator.data.DataOutputConfig;
import litll.idl.generator.data.DelitllfierOutputConfig;

class HaxeDelitllfierTypePathPair
{
	public var delitllfierPath(default, null):HaxeDelitllfierTypePath;
	public var dataPath(default, null):HaxeDataTypePath;
	
	public function new(dataPath:HaxeDataTypePath, delitllfierPath:HaxeDelitllfierTypePath) 
	{
		this.dataPath = dataPath;
		this.delitllfierPath = delitllfierPath;
	}
	
	public static function create(typePath:TypePath, dataConfig:DataOutputConfig, delitllfierConfig:DelitllfierOutputConfig):HaxeDelitllfierTypePathPair
	{
		return new HaxeDelitllfierTypePathPair(
			dataConfig.toHaxeDataPath(typePath),
			delitllfierConfig.toHaxeDelitllfierPath(typePath)
		);
	}
}

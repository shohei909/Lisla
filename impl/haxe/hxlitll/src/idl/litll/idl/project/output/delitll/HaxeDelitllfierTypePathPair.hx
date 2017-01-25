package litll.idl.project.output.delitll;
import litll.idl.project.output.data.HaxeDataTypePath;
import litll.idl.project.output.delitll.HaxeDelitllfierTypePath;
import litll.idl.std.data.idl.TypePath;
import litll.idl.project.data.DataOutputConfig;
import litll.idl.project.data.DelitllfierOutputConfig;

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

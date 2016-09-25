package litll.idl.project.output.path;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.project.DataOutputConfig;
import litll.idl.std.data.idl.project.DelitllfierOutputConfig;

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

package litll.idl.project.output.path;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.project.DataOutputConfig;
import litll.idl.std.data.idl.project.LitllfierOutputConfig;

class HaxeLitllfierTypePathPair
{
	public var delitllfierPath(default, null):HaxeLitllfierTypePath;
	public var dataPath(default, null):HaxeDataTypePath;
	
	public function new(dataPath:HaxeDataTypePath, delitllfierPath:HaxeLitllfierTypePath) 
	{
		this.dataPath = dataPath;
		this.delitllfierPath = delitllfierPath;
	}
	
	public static function create(typePath:TypePath, dataConfig:DataOutputConfig, delitllfierConfig:LitllfierOutputConfig):HaxeLitllfierTypePathPair
	{
		return new HaxeLitllfierTypePathPair(
			dataConfig.toHaxeDataPath(typePath),
			delitllfierConfig.toHaxeLitllfierPath(typePath)
		);
	}
}

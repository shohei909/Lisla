package sora.idl.project.output.path;
import sora.idl.std.data.idl.TypePath;
import sora.idl.std.data.idl.project.DataOutputConfig;
import sora.idl.std.data.idl.project.DesoralizerOutputConfig;

class HaxeDesoralizerTypePathPair
{
	public var desoralizerPath(default, null):HaxeDesoralizerTypePath;
	public var dataPath(default, null):HaxeDataTypePath;
	
	public function new(dataPath:HaxeDataTypePath, desoralizerPath:HaxeDesoralizerTypePath) 
	{
		this.dataPath = dataPath;
		this.desoralizerPath = desoralizerPath;
	}
	
	public static function create(typePath:TypePath, dataConfig:DataOutputConfig, desoralizerConfig:DesoralizerOutputConfig):HaxeDesoralizerTypePathPair
	{
		return new HaxeDesoralizerTypePathPair(
			dataConfig.toHaxeDataPath(typePath),
			desoralizerConfig.toHaxeDesoralizerPath(typePath)
		);
	}
}

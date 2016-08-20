package sora.idl.project.idl.source;
import sora.core.ds.Set;
import sora.idl.std.data.idl.TypeDefinition;
import sora.idl.std.data.idl.TypePath;
import sora.idl.std.data.idl.project.SourceConfig;

class IdlSourceProvider
{
	private var dirctories:Array<String>;
	private var loadedTypes:Map<TypePath, TypeDefinition>;
	
	public function new(homeDirectory:String, config:SourceConfig) 
	{
		var dirctories = [homeDirectory + "/std"];
		for (source in config.sources)
		{
			dirctories.push(source);
		}
		
		loadedTypes = new Map();
	}
}

package sora.idl.project.output.store;
import sora.idl.project.output.path.HaxeDataTypePath;
import sora.idl.std.data.idl.TypePath;

class HaxeDataInterfaceStore
{
	private var map:Map<String, HaxeDataInterface>;
	
	public function new() 
	{
		map = new Map();
	}	
	
	public function exists(typePath:HaxeDataTypePath):Bool 
	{
		return map.exists(typePath.toString());
	}
	
	public function add(typePath:HaxeDataTypePath, data:HaxeDataInterface):Void
	{
		map.set(typePath.toString(), data);
	}
}
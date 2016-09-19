package sora.idl.project.output.record;
import sora.idl.std.data.idl.TypePath;

class HaxeDataInterfaceRecord
{
	private var map:Map<String, HaxeDataInterface>;
	
	public function new() 
	{
		map = new Map();
	}	
	
	public function exists(typePath:TypePath):Bool 
	{
		return map.exists(typePath.toString());
	}
	
	public function add(path:TypePath, data:HaxeDataInterface):Void
	{
		map.set(path.toString(), data);
	}
}

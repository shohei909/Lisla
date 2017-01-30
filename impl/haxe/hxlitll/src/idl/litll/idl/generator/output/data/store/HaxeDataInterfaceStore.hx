package litll.idl.generator.output.data.store;
import haxe.ds.Option;
import litll.core.ds.Maybe;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.std.data.idl.TypePath;

class HaxeDataInterfaceStore
{
	private var map:Map<String, HaxeDataInterface>;
	
	public function new() 
	{
		map = new Map();
	}	
	
	public inline function exists(typePath:HaxeDataTypePath):Bool 
	{
		return map.exists(typePath.toString());
	}
	
	public inline function add(typePath:HaxeDataTypePath, data:HaxeDataInterface):Void
	{
        map.set(typePath.toString(), data);
	}
	
	public function getDataClassInterface(typePath:HaxeDataTypePath):Maybe<HaxeDataClassInterface> 
	{
		var str = typePath.toString();
        return if (map.exists(str))
		{
			switch (map.get(str).kind)
			{
				case HaxeDataInterfaceKind.Class(classData):
					Maybe.some(classData);
					
				case HaxeDataInterfaceKind.Enum(_):
					Maybe.none();
			}
		}
		else
		{
			Maybe.none();
		}
	}
}

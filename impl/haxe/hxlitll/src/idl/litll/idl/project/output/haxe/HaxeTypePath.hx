package litll.idl.project.output.haxe;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;

class HaxeTypePath
{
	private var path:TypePath;
	
	public var typeName(get, never):String;
	private function get_typeName():String
	{
		return path.typeName.toString();
	}
	
	private function new(path:TypePath)
	{
		this.path = path;
	}
	
	public function toMacroPath():haxe.macro.Expr.TypePath 
	{
		return {
			pack: path.getModuleArray(),
			name: path.typeName.toString(),
			params : []
		}
	}
	
	public function toString():String
	{
		return path.toString();
	}
	
	public function getModuleArray():Array<String>
	{
		return path.getModuleArray();
	}
}

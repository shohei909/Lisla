package litll.idl.project.source;
import litll.idl.std.data.idl.Idl;

class LoadedIdl
{
	public var file(default, null):String;
	public var data(default, null):Idl;
	
	public function new(data:Idl, file:String) 
	{
		this.file = file;
		this.data = data;
	}
}
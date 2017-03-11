package lisla.idl.generator.source.file;
import lisla.idl.std.entity.idl.Idl;

class LoadedIdl
{
	public var file(default, null):IdlFilePath;
	public var data(default, null):Idl;
	
	public function new(data:Idl, file:IdlFilePath) 
	{
		this.file = file;
		this.data = data;
	}
}
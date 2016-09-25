package litll.idl.std.data.idl.project;

class SourceConfig
{
	public var sources:Array<String>;
	public var libraries:Array<String>;
	
	public function new(sources:Array<String>, libraries:Array<String>)
	{
		this.libraries = libraries;
		this.sources = sources;
	}
}

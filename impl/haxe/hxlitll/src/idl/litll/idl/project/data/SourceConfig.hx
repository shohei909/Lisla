package litll.idl.project.data;
import litll.idl.delitllfy.DelitllfyConfig;

class SourceConfig
{
	public var sources:Array<String>;
	public var libraries:Array<String>;
	public var delitllfyConfig:DelitllfyConfig;
	
	public function new(sources:Array<String>, libraries:Array<String>)
	{
		this.libraries = libraries;
		this.sources = sources;
	}
}

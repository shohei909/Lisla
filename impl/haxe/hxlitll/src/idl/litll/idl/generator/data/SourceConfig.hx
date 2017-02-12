package litll.idl.generator.data;
import litll.idl.litll2backend.LitllToBackendConfig;

class SourceConfig
{
	public var sources:Array<String>;
	public var libraries:Array<String>;
	public var litllToBackendConfig:LitllToBackendConfig;
	
	public function new(sources:Array<String>, libraries:Array<String>)
	{
		this.libraries = libraries;
		this.sources = sources;
	}
}

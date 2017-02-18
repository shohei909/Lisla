package litll.idl.generator.data;
import litll.idl.litll2backend.LitllToEntityConfig;

class SourceConfig
{
	public var sources:Array<String>;
	public var libraries:Array<String>;
	public var litllToEntityConfig:LitllToEntityConfig;
	
	public function new(sources:Array<String>, libraries:Array<String>)
	{
		this.libraries = libraries;
		this.sources = sources;
	}
}

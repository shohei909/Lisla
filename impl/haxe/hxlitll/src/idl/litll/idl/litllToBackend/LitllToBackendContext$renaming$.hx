package litll.idl.litllToBackend;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.litllToBackend.LitllToBackendArrayContext;
import litll.idl.litllToBackend.LitllToBackendConfig;

class LitllToBackendContext
{
	public var litll(default, null):Litll;
	public var config(default, null):LitllToBackendConfig;
	
	public inline function new(litll:Litll, config:LitllToBackendConfig)
	{
		this.litll = litll;
		this.config = config;
	}
}

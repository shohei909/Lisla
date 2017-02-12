package litll.idl.litll2backend;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.litll2backend.LitllToBackendArrayContext;
import litll.idl.litll2backend.LitllToBackendConfig;

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

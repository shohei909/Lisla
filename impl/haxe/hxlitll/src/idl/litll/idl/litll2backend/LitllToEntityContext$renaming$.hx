package litll.idl.litll2backend;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.litll2backend.LitllToEntityArrayContext;
import litll.idl.litll2backend.LitllToEntityConfig;

class LitllToEntityContext
{
	public var litll(default, null):Litll;
	public var config(default, null):LitllToEntityConfig;
	
	public inline function new(litll:Litll, config:LitllToEntityConfig)
	{
		this.litll = litll;
		this.config = config;
	}
}

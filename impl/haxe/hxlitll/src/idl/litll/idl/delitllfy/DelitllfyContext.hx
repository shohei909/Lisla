package litll.idl.delitllfy;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyConfig;

class DelitllfyContext
{
	public var litll(default, null):Litll;
	public var config(default, null):DelitllfyConfig;
	
	public inline function new(litll:Litll, config:DelitllfyConfig)
	{
		this.litll = litll;
		this.config = config;
	}
}

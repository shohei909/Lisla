package litll.idl.delitllfy;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.DelitllfyArrayContext;
import litll.idl.delitllfy.DelitllfyConfig;

class DelitllfyContext
{
	public var parent(default, null):Option<DelitllfyArrayContext>;
	public var litll(default, null):Litll;
	public var config(default, null):DelitllfyConfig;
	
	public inline function new(parent:Option<DelitllfyArrayContext>, litll:Litll, config:DelitllfyConfig)
	{
		this.parent = parent;
		this.litll = litll;
		this.config = config;
	}
}

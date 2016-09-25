package litll.idl.delitllfy;
import haxe.ds.Option;
import litll.core.Litll;
import litll.idl.delitllfy.LitllArrayContext;
import litll.idl.delitllfy.LitllConfig;

class LitllContext
{
	public var parent(default, null):Option<LitllArrayContext>;
	public var litll(default, null):Litll;
	public var config(default, null):LitllConfig;
	
	public inline function new(parent:Option<LitllArrayContext>, litll:Litll, config:LitllConfig)
	{
		this.parent = parent;
		this.litll = litll;
		this.config = config;
	}
}

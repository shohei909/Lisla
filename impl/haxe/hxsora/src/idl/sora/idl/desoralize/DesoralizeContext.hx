package sora.idl.desoralize;
import haxe.ds.Option;
import sora.core.Sora;
import sora.idl.desoralize.DesoralizeArrayContext;
import sora.idl.desoralize.DesoralizeConfig;

class DesoralizeContext
{
	public var parent(default, null):Option<DesoralizeArrayContext>;
	public var sora(default, null):Sora;
	public var config(default, null):DesoralizeConfig;
	
	public inline function new(parent:Option<DesoralizeArrayContext>, sora:Sora, config:DesoralizeConfig)
	{
		this.parent = parent;
		this.sora = sora;
		this.config = config;
	}
}

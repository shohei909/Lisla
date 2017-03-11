package lisla.idl.lisla2entity;
import haxe.ds.Option;
import lisla.core.Lisla;
import lisla.idl.lisla2entity.LislaToEntityArrayContext;
import lisla.idl.lisla2entity.LislaToEntityConfig;

class LislaToEntityContext
{
	public var lisla(default, null):Lisla;
	public var config(default, null):LislaToEntityConfig;
	
	public inline function new(lisla:Lisla, config:LislaToEntityConfig)
	{
		this.lisla = lisla;
		this.config = config;
	}
}

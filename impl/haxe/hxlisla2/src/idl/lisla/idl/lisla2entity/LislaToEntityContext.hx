package lisla.idl.lisla2entity;
import haxe.ds.Option;
import lisla.data.tree.al.AlTree;
import lisla.idl.lisla2entity.LislaToEntityArrayContext;
import lisla.idl.lisla2entity.LislaToEntityConfig;

class LislaToEntityContext
{
	public var lisla(default, null):AlTree<String>;
	public var config(default, null):LislaToEntityConfig;
	
	public inline function new(lisla:AlTree<String>, config:LislaToEntityConfig)
	{
		this.lisla = lisla;
		this.config = config;
	}
}

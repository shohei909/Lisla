package arraytree.idl.arraytree2entity;
import haxe.ds.Option;
import arraytree.data.tree.al.AlTree;
import arraytree.idl.arraytree2entity.ArrayTreeToEntityArrayContext;
import arraytree.idl.arraytree2entity.ArrayTreeToEntityConfig;

class ArrayTreeToEntityContext
{
	public var arraytree(default, null):AlTree<String>;
	public var config(default, null):ArrayTreeToEntityConfig;
	
	public inline function new(arraytree:AlTree<String>, config:ArrayTreeToEntityConfig)
	{
		this.arraytree = arraytree;
		this.config = config;
	}
}

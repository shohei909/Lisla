package arraytree.idl.generator.output.entity.store;

class HaxeEntityClassInterface
{
	public var arraytreeToEntity(default, null):HaxeEntityConstructorKind;

	public function new(arraytreeToEntity:HaxeEntityConstructorKind) 
	{
		this.arraytreeToEntity = arraytreeToEntity;
	}
}

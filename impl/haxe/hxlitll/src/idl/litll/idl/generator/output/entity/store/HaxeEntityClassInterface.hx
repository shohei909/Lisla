package lisla.idl.generator.output.entity.store;

class HaxeEntityClassInterface
{
	public var lislaToEntity(default, null):HaxeEntityConstructorKind;

	public function new(lislaToEntity:HaxeEntityConstructorKind) 
	{
		this.lislaToEntity = lislaToEntity;
	}
}

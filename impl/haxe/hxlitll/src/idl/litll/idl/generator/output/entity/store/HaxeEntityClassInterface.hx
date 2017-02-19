package litll.idl.generator.output.entity.store;

class HaxeEntityClassInterface
{
	public var litllToEntity(default, null):HaxeEntityConstructorKind;

	public function new(litllToEntity:HaxeEntityConstructorKind) 
	{
		this.litllToEntity = litllToEntity;
	}
}

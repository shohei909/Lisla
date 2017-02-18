package litll.idl.generator.output.data.store;

class HaxeDataClassInterface
{
	public var litllToEntity(default, null):HaxeDataConstructorKind;

	public function new(litllToEntity:HaxeDataConstructorKind) 
	{
		this.litllToEntity = litllToEntity;
	}
}

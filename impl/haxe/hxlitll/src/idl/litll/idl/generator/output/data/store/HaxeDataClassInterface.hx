package litll.idl.generator.output.data.store;

class HaxeDataClassInterface
{
	public var litllToBackend(default, null):HaxeDataConstructorKind;

	public function new(litllToBackend:HaxeDataConstructorKind) 
	{
		this.litllToBackend = litllToBackend;
	}
}

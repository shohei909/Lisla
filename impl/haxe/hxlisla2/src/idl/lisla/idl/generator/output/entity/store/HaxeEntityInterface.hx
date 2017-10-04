package arraytree.idl.generator.output.entity.store;
import arraytree.idl.generator.output.entity.EntityHaxeTypePath;

class HaxeEntityInterface
{
    public var kind:HaxeEntityInterfaceKind;
	public var path:EntityHaxeTypePath;
	
	public function new (path:EntityHaxeTypePath, kind:HaxeEntityInterfaceKind)
	{
        this.path = path;
		this.kind = kind;
	}
}

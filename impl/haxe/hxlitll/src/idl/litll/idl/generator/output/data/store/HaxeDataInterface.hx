package litll.idl.generator.output.data.store;
import litll.idl.generator.output.data.HaxeDataTypePath;

class HaxeDataInterface
{
    public var kind:HaxeDataInterfaceKind;
	public var path:HaxeDataTypePath;
	
	public function new (path:HaxeDataTypePath, kind:HaxeDataInterfaceKind)
	{
        this.path = path;
		this.kind = kind;
	}
}

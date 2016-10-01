package litll.idl.project.output.store;
import litll.idl.project.output.data.HaxeDataTypePath;

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

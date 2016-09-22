package sora.idl.project.output.store;
import sora.idl.project.output.path.HaxeDataTypePath;

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

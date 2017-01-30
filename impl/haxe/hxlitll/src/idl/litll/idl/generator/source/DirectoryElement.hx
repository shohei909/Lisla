package litll.idl.generator.source;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypePath;
import sys.FileSystem;

class DirectoryElement
{
	private var root:RootPackageElement;
	
	public var children:Map<String, PackageElement>;
	public var path(default, null):Array<String>;
	public var loaded(default, null):Bool;
	
	public function new(root:RootPackageElement, path:Array<String>) 
	{
		this.root = root;
		this.path = path;
		children = new Map<String, PackageElement>();
		loaded = false;
		init();
	}
	
	private function init():Void
	{
		if (!root.reader.directoryExists(path))
		{
			loaded = true;	
		}
	}
	
	public function addChild(head:String):PackageElement
	{
		if (children.exists(head)) return children[head];
		return children[head] = new PackageElement(root, path.concat([head]));
	}
	
	public function loadChildren():Void
	{
		if (loaded) return;
		
		for (childName in root.reader.getChildren(path))
		{
			addChild(childName).loadChildren();
		}
		
		loaded = true;
	}
	
	public function fetchChildren(output:Map<String, TypeDefinition>):Void 
	{
		loadChildren();
		for (child in children)
		{
			child.fetchChildren(output);
		}
	}
}

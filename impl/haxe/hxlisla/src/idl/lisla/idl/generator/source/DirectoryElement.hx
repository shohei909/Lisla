package lisla.idl.generator.source;
import lisla.idl.generator.source.validate.ValidType;
import lisla.idl.library.Library;
import lisla.idl.library.LoadTypesContext;
import lisla.idl.library.PackageElement;
import lisla.idl.std.entity.idl.PackagePath;

class DirectoryElement
{
    // ========================
    // Parent
    // ========================
    public var packageElement(default, null):PackageElement;
    
    // ========================
    // Child
    // ========================
	public var children:Map<String, PackageElement>;
	public var loaded(default, null):Bool;
	
    // ========================
    // Getter
    // ========================
    private var library(get, never):Library;
    private inline function get_library():Library 
    {
        return packageElement.library;
    }
    public var path(get, never):PackagePath;
    private function get_path():PackagePath
    {
        return packageElement.path;
    }
    
	public function new(packageElement:PackageElement) 
	{
		this.packageElement = packageElement;
		children = new Map<String, PackageElement>();
		loaded = false;
		init();
	}
	
	private function init():Void
	{
		if (!library.directoryExistsAt(path))
		{
			loaded = true;	
		}
	}
	
	public function addChild(head:String):PackageElement
	{
		if (children.exists(head)) return children[head];
		return children[head] = new PackageElement(library, path.concat([head]));
	}
	
	public function resolveChildren(context:LoadTypesContext):Void
	{
		if (loaded) return;
		
		for (childName in library.getChildrenAt(path))
		{
			addChild(childName).resolveChildren(context);
		}
		
		loaded = true;
	}
    
	public function fetchChildren(context:LoadTypesContext, output:Array<ValidType>):Void 
	{
		resolveChildren(context);
		for (child in children)
		{
			child.fetchChildren(context, output);
		}
	}
}

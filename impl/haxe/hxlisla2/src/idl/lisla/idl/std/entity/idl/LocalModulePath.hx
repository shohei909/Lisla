package arraytree.idl.std.entity.idl;
import hxext.ds.Maybe;
import arraytree.data.meta.core.Metadata;

class LocalModulePath 
{
    public var path(default, null):Array<String>;
	public var metadata(default, null):Metadata;
    
	public function new(path:Array<String>, metadata:Metadata)
	{
		this.path = path;
        this.metadata = metadata;
        
		for (segment in path)
		{
			PackagePath.validateElement(segment);
		}
	}   
}
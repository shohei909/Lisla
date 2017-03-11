package lisla.idl.std.entity.idl;
import hxext.ds.Maybe;
import lisla.core.tag.StringTag;

class LocalModulePath 
{
    public var path(default, null):Array<String>;
	public var tag(default, null):Maybe<StringTag>;
    
	public function new(path:Array<String>, ?tag:Maybe<StringTag>)
	{
		this.path = path;
        this.tag = tag;
        
		for (segment in path)
		{
			PackagePath.validateElement(segment);
		}
	}   
}
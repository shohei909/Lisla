package sora.idl.project.structure.haxe;
import sora.core.ds.Set;
import sora.idl.std.data.idl.TypePath;
import sora.idl.std.data.idl.TypeDefinition;
import sora.idl.std.data.idl.TypePathMatcher;

class IdlToHaxeWriterConfig
{
	public var loadedTypes(default, null):Map<TypePath, TypeDefinition>;
	public var dataStructureConfig(default, null):Set<TypePath>;
	public var rename(default, null):Map<TypePath, TypePath>;
	
	public function new(loadedTypes:Map<TypePath, TypeDefinition>) 
	{
		this.loadedTypes = loadedTypes;
	}
	
	public function include(path:String):Void
	{
		
	}
	
	public function rename(matchingPath:String, renamedPath:String):Void
	{
	}
}

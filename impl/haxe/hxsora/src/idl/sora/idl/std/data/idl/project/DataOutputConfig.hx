package sora.idl.std.data.idl.project;
import sora.idl.std.data.idl.path.TypePathPrefix;
import sora.idl.std.data.idl.path.TypeRenameFilter;

class DataOutputConfig
{
	public var targets:Array<TypePathPrefix>;
	public var filters:Array<TypeRenameFilter>;
	
	public function new() 
	{
		
	}
}
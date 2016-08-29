package sora.idl.project;
import sora.idl.std.data.idl.project.ProjectConfig;
import sora.idl.project.output.IdlOutputRunner;
import sora.idl.project.source.IdlSourceProvider;

class IdlProjectRunner
{
	public var homeDirectory(default, null):String;
	public var config(default, null):ProjectConfig;
	
	public function new(homeDirectory:String, config:ProjectConfig) 
	{
		this.homeDirectory = homeDirectory;
		this.config = config;
	}
	
	public inline function run():Void
	{
	}
}

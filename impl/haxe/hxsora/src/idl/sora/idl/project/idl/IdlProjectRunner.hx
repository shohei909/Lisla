package sora.idl.project.idl;
import sora.idl.std.data.idl.project.ProjectConfig;
import sora.idl.project.idl.output.IdlOutputRunner;
import sora.idl.project.idl.source.IdlSourceProvider;

class IdlProjectRunner
{
	public var homeDirectory(default, null):String;
	public var config(default, null):ProjectConfig;
	
	public inline function new(homeDirectory:String, config:ProjectConfig) 
	{
		this.homeDirectory = homeDirectory;
		this.config = config;
	}
	
	public inline function run():Void
	{
	}
}

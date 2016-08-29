package sora.idl.project.output;
import haxe.ds.Option;
import sora.idl.project.source.IdlSourceProvider;
import sora.idl.std.data.idl.project.OutputConfig;

class IdlOutputRunner
{
	public static function run(provider:IdlSourceProvider, outputConfig:OutputConfig):Void
	{
		IdlDataOutputRunner.run(provider, outputConfig.dataOutputConfig);
		
		switch (outputConfig.desoralizerOutputConfig)
		{
			case Option.Some(desoralizerOutputConfig):
				IdlDesoralizerOutputRunner.run(provider, outputConfig.dataOutputConfig, desoralizerOutputConfig);
				
			case Option.None:
				// nothing to do...
		}
	}
}

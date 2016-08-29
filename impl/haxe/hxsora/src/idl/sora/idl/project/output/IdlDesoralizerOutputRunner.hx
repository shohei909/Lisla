package sora.idl.project.output;
import sora.idl.std.data.idl.project.DataOutputConfig;
import sora.idl.project.source.IdlSourceProvider;
import sora.idl.std.data.idl.project.DesoralizerOutputConfig;

class IdlDesoralizerOutputRunner
{
	static public function run(provider:IdlSourceProvider, dataConfig:DataOutputConfig, desoralizerConfig:DesoralizerOutputConfig) 
	{
		var targetTypes = provider.resolveGroups(dataConfig.targets);
		
	}	
}
package sora.idl.project.output;
import sora.core.ds.Result;
import sora.idl.std.data.idl.project.DataOutputConfig;
import sora.idl.project.source.IdlSourceProvider;

class IdlDataOutputRunner
{
	public static function run(provider:IdlSourceProvider, dataOutputConfig:DataOutputConfig):Void
	{
		switch(provider.resolveGroups(dataOutputConfig.targets))
		{
			case Result.Ok(data):
				trace(data);
				
			case Result.Err(errors):
				trace(errors.map(function (e) return e.toString()).join("\n"));
		}
	}
}

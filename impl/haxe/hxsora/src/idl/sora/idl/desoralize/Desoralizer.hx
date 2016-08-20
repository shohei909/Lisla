package sora.idl.desoralize;
import haxe.ds.Option;
import sora.core.Sora;
import sora.core.SoraArray;
import sora.core.ds.Result;

class Desoralizer
{
	public static function run<T>(process:DesoralizeContext->Result<T, DesoralizeError>, sora:SoraArray, ?config:DesoralizeConfig):Result<T, DesoralizeError>
	{
		if (config == null)
		{
			config = new DesoralizeConfig();
		}
		
		var context = new DesoralizeContext(Option.None, Sora.Arr(sora), config);
		return process(context);
	}
	
	public static function processSora(context:DesoralizeContext):Result<Sora, DesoralizeError>
	{
		return Result.Ok(context.sora);
	}
}

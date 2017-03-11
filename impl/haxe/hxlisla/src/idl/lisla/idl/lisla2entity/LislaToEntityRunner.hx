package lisla.idl.lisla2entity;
import haxe.ds.Option;
import lisla.core.Lisla;
import lisla.core.LislaArray;
import hxext.ds.Result;
import lisla.idl.lisla2entity.error.LislaToEntityError;

class LislaToEntityRunner
{
	public static function run<T>(processorType:LislaToEntityType<T>, lisla:LislaArray<Lisla>, ?config:LislaToEntityConfig):Result<T, LislaToEntityError>
	{
		if (config == null)
		{
			config = new LislaToEntityConfig();
		}
		
		var context = new LislaToEntityContext(Lisla.Arr(lisla), config);
		return processorType.process(context);
	}
	
	public static function processLisla(context:LislaToEntityContext):Result<Lisla, LislaToEntityError>
	{
		return Result.Ok(context.lisla);
	}
}

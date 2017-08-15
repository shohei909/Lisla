package lisla.idl.lisla2entity;
import hxext.ds.Result;
import lisla.data.meta.core.ArrayWithMetadata;
import lisla.data.tree.al.AlTree;
import lisla.idl.lisla2entity.error.LislaToEntityError;

class LislaToEntityRunner
{
	public static function run<T>(
        processorType:LislaToEntityType<T>, 
        array:ArrayWithMetadata<AlTree<String>>, 
        ?config:LislaToEntityConfig
    ):Result<T, Array<LislaToEntityError>>
	{
		if (config == null)
		{
			config = new LislaToEntityConfig();
		}
		
		var context = new LislaToEntityContext(AlTree.fromArray(array), config);
		return processorType.process(context);
	}
	
	public static function processLisla(context:LislaToEntityContext):Result<AlTree<String>, Array<LislaToEntityError>>
	{
		return Result.Ok(context.lisla);
	}
}

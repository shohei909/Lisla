package arraytree.idl.arraytree2entity;
import hxext.ds.Result;
import arraytree.data.meta.core.ArrayWithMetadata;
import arraytree.data.tree.al.AlTree;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError;

class ArrayTreeToEntityRunner
{
	public static function run<T>(
        processorType:ArrayTreeToEntityType<T>, 
        array:ArrayWithMetadata<AlTree<String>>, 
        ?config:ArrayTreeToEntityConfig
    ):Result<T, Array<ArrayTreeToEntityError>>
	{
		if (config == null)
		{
			config = new ArrayTreeToEntityConfig();
		}
		
		var context = new ArrayTreeToEntityContext(AlTree.fromArray(array), config);
		return processorType.process(context);
	}
	
	public static function processArrayTree(context:ArrayTreeToEntityContext):Result<AlTree<String>, Array<ArrayTreeToEntityError>>
	{
		return Result.Ok(context.arraytree);
	}
}

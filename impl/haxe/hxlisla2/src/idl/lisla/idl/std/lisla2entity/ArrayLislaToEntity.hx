package arraytree.idl.std.arraytree2entity;
import hxext.ds.Result;
import arraytree.data.meta.core.ArrayWithtag;
import arraytree.data.tree.al.AlTree;
import arraytree.data.tree.al.AlTreeKind;
import arraytree.idl.arraytree2entity.ArrayTreeToEntityContext;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind;

class ArrayArrayTreeToEntity
{
    public static function process<T>(context:ArrayTreeToEntityContext, tArrayTreeToEntity):Result<ArrayWithtag<AlTree<T>>, Array<ArrayTreeToEntityError>> 
	{
		return switch (context.arraytree.kind)
		{
			case AlTreeKind.Leaf(string):
				Result.Error(ArrayTreeToEntityError.ofArrayTree(context.arraytree, ArrayTreeToEntityErrorKind.CantBeString));
				
			case AlTreeKind.Arr(array):
				var data = [];
				for (arraytree in array)
				{
					var tContext = new ArrayTreeToEntityContext(arraytree, context.config);
					switch (tArrayTreeToEntity.process(tContext))
					{
						case Result.Error(error):
							Result.Error(error);
						
						case Result.Ok(o):
							data.push(o);
					}
				}
				Result.Ok(new ArrayWithtag(data, context.arraytree.tag));
		}
	}
}

package arraytree.idl.std.arraytree2entity;
import hxext.ds.Result;
import arraytree.data.tree.al.AlTree;
import arraytree.data.meta.core.StringWithtag;
import arraytree.data.tree.al.AlTreeKind;
import arraytree.idl.arraytree2entity.ArrayTreeToEntityContext;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind;

class StringArrayTreeToEntity
{
	public static inline function process(context:ArrayTreeToEntityContext):Result<StringWithtag, Array<ArrayTreeToEntityError>> 
	{
		return switch (context.arraytree.kind)
		{
			case AlTreeKind.Leaf(string):
				Result.Ok(new StringWithtag(string, context.arraytree.tag));
				
			case AlTreeKind.Arr(array):
				Result.Error(ArrayTreeToEntityError.ofArrayTree(context.arraytree, ArrayTreeToEntityErrorKind.CantBeArray));
		}
	}
}

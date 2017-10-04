package lisla.idl.std.lisla2entity;
import hxext.ds.Result;
import lisla.data.tree.al.AlTree;
import lisla.data.meta.core.StringWithtag;
import lisla.data.tree.al.AlTreeKind;
import lisla.idl.lisla2entity.LislaToEntityContext;
import lisla.idl.lisla2entity.error.LislaToEntityError;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;

class StringLislaToEntity
{
	public static inline function process(context:LislaToEntityContext):Result<StringWithtag, Array<LislaToEntityError>> 
	{
		return switch (context.lisla.kind)
		{
			case AlTreeKind.Leaf(string):
				Result.Ok(new StringWithtag(string, context.lisla.tag));
				
			case AlTreeKind.Arr(array):
				Result.Error(LislaToEntityError.ofLisla(context.lisla, LislaToEntityErrorKind.CantBeArray));
		}
	}
}

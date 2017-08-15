package lisla.idl.std.lisla2entity;
import hxext.ds.Result;
import lisla.data.meta.core.ArrayWithMetadata;
import lisla.data.tree.al.AlTree;
import lisla.data.tree.al.AlTreeKind;
import lisla.idl.lisla2entity.LislaToEntityContext;
import lisla.idl.lisla2entity.error.LislaToEntityError;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;

class ArrayLislaToEntity
{
    public static function process<T>(context:LislaToEntityContext, tLislaToEntity):Result<ArrayWithMetadata<AlTree<T>>, Array<LislaToEntityError>> 
	{
		return switch (context.lisla.kind)
		{
			case AlTreeKind.Leaf(string):
				Result.Error(LislaToEntityError.ofLisla(context.lisla, LislaToEntityErrorKind.CantBeString));
				
			case AlTreeKind.Arr(array):
				var data = [];
				for (lisla in array)
				{
					var tContext = new LislaToEntityContext(lisla, context.config);
					switch (tLislaToEntity.process(tContext))
					{
						case Result.Error(error):
							Result.Error(error);
						
						case Result.Ok(o):
							data.push(o);
					}
				}
				Result.Ok(new ArrayWithMetadata(data, context.lisla.metadata));
		}
	}
}

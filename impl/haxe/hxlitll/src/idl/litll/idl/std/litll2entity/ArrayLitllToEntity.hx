package lisla.idl.std.lisla2entity;
import lisla.core.Lisla;
import lisla.core.LislaArray;
import hxext.ds.Result;
import lisla.idl.lisla2entity.LislaToEntityArrayContext;
import lisla.idl.lisla2entity.LislaToEntityContext;
import lisla.idl.lisla2entity.error.LislaToEntityError;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;

class ArrayLislaToEntity
{
    public static function process<T>(context:LislaToEntityContext, tLislaToEntity):Result<LislaArray<T>, LislaToEntityError> 
	{
		return switch (context.lisla)
		{
			case Lisla.Str(string):
				Result.Err(LislaToEntityError.ofLisla(context.lisla, LislaToEntityErrorKind.CantBeString));
				
			case Lisla.Arr(array):
				var data = [];
				for (lisla in array.data)
				{
					var tContext = new LislaToEntityContext(lisla, context.config);
					switch (tLislaToEntity.process(tContext))
					{
						case Result.Err(error):
							Result.Err(error);
						
						case Result.Ok(o):
							data.push(o);
					}
				}
				Result.Ok(new LislaArray(data, array.tag));
		}
	}
}

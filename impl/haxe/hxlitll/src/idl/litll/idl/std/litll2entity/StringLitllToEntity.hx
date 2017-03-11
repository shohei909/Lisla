package lisla.idl.std.lisla2entity;
import hxext.ds.Result;
import lisla.core.Lisla;
import lisla.core.LislaString;
import lisla.idl.lisla2entity.LislaToEntityContext;
import lisla.idl.lisla2entity.error.LislaToEntityError;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;

class StringLislaToEntity
{
	public static inline function process(context:LislaToEntityContext):Result<LislaString, LislaToEntityError> 
	{
		return switch (context.lisla)
		{
			case Lisla.Str(string):
				Result.Ok(string);
				
			case Lisla.Arr(array):
				Result.Err(LislaToEntityError.ofLisla(context.lisla, LislaToEntityErrorKind.CantBeArray));
		}
	}
}

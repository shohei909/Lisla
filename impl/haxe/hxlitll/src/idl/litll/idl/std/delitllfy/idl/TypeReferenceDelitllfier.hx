package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyUnionContext;
import litll.core.ds.Result;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.delitllfy.idl.GenericTypeReferenceDelitllfier;
import litll.idl.std.delitllfy.idl.TypePathDelitllfier;
import litll.idl.std.delitllfy.idl.TypeReferenceDelitllfier;
using litll.core.ds.ResultTools;

class TypeReferenceDelitllfier
{
	public static function process(context:DelitllfyContext):Result<TypeReference, DelitllfyError> 
	{
		return try
		{
			var unionContext = new DelitllfyUnionContext(context);
			switch (unionContext.read(TypePathDelitllfier.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(TypeReference.Primitive(data));
					
				case Option.None:
			}
			switch (unionContext.read(GenericTypeReferenceDelitllfier.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(TypeReference.Generic(data));
					
				case Option.None:
			}
			unionContext.close();
		}
		catch (e:DelitllfyError)
		{
			Result.Err(e);
		}
	}
}

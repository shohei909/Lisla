package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyUnionContext;
import litll.core.ds.Result;
import litll.idl.std.data.idl.TypeNameDeclaration;
import litll.idl.std.delitllfy.idl.GenericTypeNameDelitllfier;
import litll.idl.std.delitllfy.idl.TypeNameDeclarationDelitllfier;
import litll.idl.std.delitllfy.idl.TypeNameDelitllfier;
using litll.core.ds.ResultTools;

class TypeNameDeclarationDelitllfier
{
	public static function process(context:DelitllfyContext):Result<TypeNameDeclaration, DelitllfyError> 
	{
		return try
		{
			var unionContext = new DelitllfyUnionContext(context);
			switch (unionContext.read(TypeNameDelitllfier.process).getOrThrow().toOption())
			{
				case Option.Some(data):
					return Result.Ok(TypeNameDeclaration.Primitive(data));
					
				case Option.None:
			}
			switch (unionContext.read(GenericTypeNameDelitllfier.process).getOrThrow().toOption())
			{
				case Option.Some(data):
					return Result.Ok(TypeNameDeclaration.Generic(data));
					
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

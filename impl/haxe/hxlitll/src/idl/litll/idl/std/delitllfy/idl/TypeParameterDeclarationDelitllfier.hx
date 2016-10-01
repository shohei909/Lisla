package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyUnionContext;
import litll.core.ds.Result;
import litll.idl.std.data.idl.TypeParameterDeclaration;
import litll.idl.std.delitllfy.idl.TypeDependenceDeclarationDelitllfier;
import litll.idl.std.delitllfy.idl.TypeNameDelitllfier;
import litll.idl.std.delitllfy.idl.TypeParameterDeclarationDelitllfier;
using litll.core.ds.ResultTools;

class TypeParameterDeclarationDelitllfier
{
	public static function process(context:DelitllfyContext):Result<TypeParameterDeclaration, DelitllfyError> 
	{
		return try
		{
			var unionContext = new DelitllfyUnionContext(context);
			switch (unionContext.read(TypeNameDelitllfier.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(TypeParameterDeclaration.TypeName(data));
					
				case Option.None:
			}
			switch (unionContext.read(TypeDependenceDeclarationDelitllfier.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(TypeParameterDeclaration.Dependence(data));
					
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
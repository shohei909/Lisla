package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.delitllfy.DelitllfyUnionContext;
import litll.core.ds.Result;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.delitllfy.idl.EnumConstructorDelitllfier;
import litll.idl.std.delitllfy.idl.EnumConstructorNameDelitllfier;
import litll.idl.std.delitllfy.idl.ParameterizedEnumConstructorDelitllfier;
using litll.core.ds.ResultTools;

class EnumConstructorDelitllfier
{
	
	public static function process(context:DelitllfyContext):Result<EnumConstructor, DelitllfyError> 
	{
		return try
		{
			var unionContext = new DelitllfyUnionContext(context);
			switch (unionContext.read(EnumConstructorNameDelitllfier.process).getOrThrow().toOption())
			{
				case Option.Some(data):
					return Result.Ok(EnumConstructor.Primitive(data));
					
				case Option.None:
			}
			switch (unionContext.read(ParameterizedEnumConstructorDelitllfier.process).getOrThrow().toOption())
			{
				case Option.Some(data):
					return Result.Ok(EnumConstructor.Parameterized(data));
					
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

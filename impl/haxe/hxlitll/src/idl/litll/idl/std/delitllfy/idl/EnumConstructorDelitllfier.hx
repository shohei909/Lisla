package litll.idl.std.delitllfy.idl;
import haxe.ds.Option;
import litll.idl.delitllfy.LitllContext;
import litll.idl.delitllfy.LitllError;
import litll.idl.delitllfy.LitllUnionContext;
import litll.core.ds.Result;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.TypeReference;
using litll.core.ds.ResultTools;

class EnumConstructorLitllfier
{
	
	public static function process(context:LitllContext):Result<EnumConstructor, LitllError> 
	{
		return try
		{
			var unionContext = new LitllUnionContext(context);
			switch (unionContext.read(EnumConstructorNameLitllfier.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(EnumConstructor.Primitive(data));
					
				case Option.None:
			}
			switch (unionContext.read(ParameterizedEnumConstructorLitllfier.process).getOrThrow())
			{
				case Option.Some(data):
					return Result.Ok(EnumConstructor.Parameterized(data));
					
				case Option.None:
			}
			unionContext.close();
		}
		catch (e:LitllError)
		{
			Result.Err(e);
		}
	}
}

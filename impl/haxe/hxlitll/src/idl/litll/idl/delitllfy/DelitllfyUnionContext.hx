package litll.idl.delitllfy;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.ds.Result;
using Lambda;

class LitllUnionContext
{
	private var parent:LitllContext;
	private var maybeErrors:Array<LitllError>;
	
	public inline function new (parent:LitllContext)
	{
		this.parent = parent;
		maybeErrors = [];
	}
	
	public inline function read<T>(process:ProcessFunction<T>):Result<Option<T>, LitllError>
	{
		return switch (process(parent))
		{
			case Result.Ok(data):
				Result.Ok(Option.Some(data));
		
			case Result.Err(error):
				if (error.recoverable())
				{
					maybeErrors.push(error);
					Result.Ok(Option.None);
				}
				else
				{
					createErrorResult(error);
				}
		}
	}
	
	public inline function close<T>():Result<T, LitllError>
	{
		return createErrorResult(LitllError.ofLitll(parent.litll, LitllErrorKind.UnmatchedUnion));
	}
	
	private inline function createErrorResult<T>(error:LitllError):Result<T, LitllError>
	{
		maybeErrors.iter(error.maybeCauses.push);
		maybeErrors = [];
		
		return Result.Err(error);
	}
}

private typedef ProcessFunction<T> = LitllContext->Result<T, LitllError>;

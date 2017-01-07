package litll.idl.delitllfy;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
using Lambda;

class DelitllfyUnionContext
{
	private var parent:DelitllfyContext;
	private var maybeErrors:Array<DelitllfyError>;
	
	public inline function new (parent:DelitllfyContext)
	{
		this.parent = parent;
		maybeErrors = [];
	}
	
	public inline function read<T>(process:ProcessFunction<T>):Result<Maybe<T>, DelitllfyError>
	{
		return switch (process(parent))
		{
			case Result.Ok(data):
				Result.Ok(Maybe.some(data));
		
			case Result.Err(error):
				if (error.recoverable())
				{
					maybeErrors.push(error);
					Result.Ok(Maybe.none());
				}
				else
				{
					createErrorResult(error);
				}
		}
	}
	
	public inline function close<T>():Result<T, DelitllfyError>
	{
		return createErrorResult(DelitllfyError.ofLitll(parent.litll, DelitllfyErrorKind.UnmatchedUnion));
	}
	
	private inline function createErrorResult<T>(error:DelitllfyError):Result<T, DelitllfyError>
	{
		maybeErrors.iter(error.maybeCauses.push);
		maybeErrors = [];
		
		return Result.Err(error);
	}
}

private typedef ProcessFunction<T> = DelitllfyContext->Result<T, DelitllfyError>;

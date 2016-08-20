package sora.idl.desoralize;
import haxe.ds.Option;
import sora.core.Sora;
import sora.core.ds.Result;
using Lambda;

class DesoralizeUnionContext
{
	private var parent:DesoralizeContext;
	private var maybeErrors:Array<DesoralizeError>;
	
	public inline function new (parent:DesoralizeContext)
	{
		this.parent = parent;
		maybeErrors = [];
	}
	
	public inline function read<T>(process:ProcessFunction<T>):Result<Option<T>, DesoralizeError>
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
	
	public inline function close<T>():Result<T, DesoralizeError>
	{
		return createErrorResult(DesoralizeError.ofSora(parent.sora, DesoralizeErrorKind.UnmatchedUnion));
	}
	
	private inline function createErrorResult<T>(error:DesoralizeError):Result<T, DesoralizeError>
	{
		maybeErrors.iter(error.maybeCauses.push);
		maybeErrors = [];
		
		return Result.Err(error);
	}
}

private typedef ProcessFunction<T> = DesoralizeContext->Result<T, DesoralizeError>;

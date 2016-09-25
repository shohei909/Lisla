package litll.idl.delitllfy;

import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.ds.Result;
using Lambda;

class LitllArrayContext
{
	private var parent:LitllContext;
	private var array:LitllArray;
	private var index:Int;
	
	private var error:Option<LitllError>;
	private var maybeErrors:Array<LitllError>;
	
	public inline function new (parent:LitllContext, array:LitllArray, index:Int)
	{
		this.parent = parent;
		this.array = array;
		this.index = index;
		
		error = Option.None;
		maybeErrors = [];
	}
	
	public function readRest<T>(process:ProcessFunction<T>):Result<Array<T>, LitllError> 
	{
		var result = [];
		
		while (true)
		{
			switch (readData(process))
			{
				case Result.Ok(data):
					result.push(data);
					
				case Result.Err(error):
					index--;
					
					if (error.recoverable())
					{
						maybeErrors.push(error);
						break;
					}
					else
					{
						return createErrorResult(error);
					}
			}
		}
		
		return Result.Ok(result);
	}
	
	public inline function readWithDefault<T>(process:ProcessFunction<T>, defaultValue:T):Result<T, LitllError>
	{
		return switch (readData(process))
		{
			case Result.Ok(data):
				Result.Ok(data);
				
			case Result.Err(error):
				index--;
				if (error.recoverable())
				{
					maybeErrors.push(error);
					Result.Ok(defaultValue);
				}
				else
				{
					createErrorResult(error);
				}
		}
	}
	
	public inline function read<T>(process:ProcessFunction<T>):Result<T, LitllError>
	{
		return switch (readData(process))
		{
			case Result.Ok(data):
				Result.Ok(data);
				
			case Result.Err(error):
				createErrorResult(error);
		}
	}
	
	private function createErrorResult<T>(error:LitllError):Result<T, LitllError>
	{
		maybeErrors.iter(error.maybeCauses.push);
		maybeErrors = [];
		
		return if (parent.config.persevering)
		{
			addFatalError(error);
			Result.Ok(null);
		}
		else
		{
			Result.Err(error);
		}
	}

	
	private inline function readData<T>(process:ProcessFunction<T>):Result<T, LitllError>
	{
		index++;
		
		if (array.data.length < index)
		{
			return Result.Err(createError(LitllErrorKind.EndOfArray));
		}
		
		var context = new LitllContext(Option.Some(this), array.data[index - 1], parent.config);
		return switch (process(context))
		{
			case Result.Err(childError):
				Result.Err(childError);
				
			case Result.Ok(data):
				Result.Ok(data);
		}
	}

	public inline function close<T>(create:Void->T):Result<T, LitllError>
	{
		if (index < array.data.length)
		{
			addFatalError(createError(LitllErrorKind.TooLongArray));
		}
		
		return switch (error)
		{
			case Option.Some(error):
				Result.Err(error);
			
			case Option.None:
				Result.Ok(create());
		}
	}
	
	private function createError(kind:LitllErrorKind):LitllError
	{
		var e = LitllError.ofArray(array, index, kind, maybeErrors);
		maybeErrors = [];
		return e;
	}
	
	public function addFatalError(nextError:LitllError):Void
	{
		switch (error)
		{
			case Option.Some(_error):
				_error.followings.push(nextError);
				
			case Option.None:
				error = Option.Some(nextError);
		}
	}
}

private typedef ProcessFunction<T> = LitllContext->Result<T, LitllError>;

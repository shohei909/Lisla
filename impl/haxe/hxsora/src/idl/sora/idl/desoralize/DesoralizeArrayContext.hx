package sora.idl.desoralize;

import haxe.ds.Option;
import sora.core.Sora;
import sora.core.SoraArray;
import sora.core.ds.Result;
using Lambda;

class DesoralizeArrayContext
{
	private var parent:DesoralizeContext;
	private var array:SoraArray;
	private var index:Int;
	
	private var error:Option<DesoralizeError>;
	private var maybeErrors:Array<DesoralizeError>;
	
	public inline function new (parent:DesoralizeContext, array:SoraArray, index:Int)
	{
		this.parent = parent;
		this.array = array;
		this.index = index;
		
		error = Option.None;
		maybeErrors = [];
	}
	
	public function readRest<T>(process:ProcessFunction<T>):Result<Array<T>, DesoralizeError> 
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
	
	public inline function readWithDefault<T>(process:ProcessFunction<T>, defaultValue:T):Result<T, DesoralizeError>
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
	
	public inline function read<T>(process:ProcessFunction<T>):Result<T, DesoralizeError>
	{
		return switch (readData(process))
		{
			case Result.Ok(data):
				Result.Ok(data);
				
			case Result.Err(error):
				createErrorResult(error);
		}
	}
	
	private function createErrorResult<T>(error:DesoralizeError):Result<T, DesoralizeError>
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

	
	private inline function readData<T>(process:ProcessFunction<T>):Result<T, DesoralizeError>
	{
		index++;
		
		if (array.data.length < index)
		{
			return Result.Err(createError(DesoralizeErrorKind.EndOfArray));
		}
		
		var context = new DesoralizeContext(Option.Some(this), array.data[index - 1], parent.config);
		return switch (process(context))
		{
			case Result.Err(childError):
				Result.Err(childError);
				
			case Result.Ok(data):
				Result.Ok(data);
		}
	}

	public inline function close<T>(create:Void->T):Result<T, DesoralizeError>
	{
		if (index < array.data.length)
		{
			addFatalError(createError(DesoralizeErrorKind.TooLongArray));
		}
		
		return switch (error)
		{
			case Option.Some(error):
				Result.Err(error);
			
			case Option.None:
				Result.Ok(create());
		}
	}
	
	private function createError(kind:DesoralizeErrorKind):DesoralizeError
	{
		var e = DesoralizeError.ofArray(array, index, kind, maybeErrors);
		maybeErrors = [];
		return e;
	}
	
	public function addFatalError(nextError:DesoralizeError):Void
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

private typedef ProcessFunction<T> = DesoralizeContext->Result<T, DesoralizeError>;

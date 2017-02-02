package litll.idl.delitllfy;

import haxe.PosInfos;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
using Lambda;

class DelitllfyArrayContext
{
	private var array:LitllArray<Litll>;
	public var index:Int;
	
	private var error:Maybe<DelitllfyError>;
	private var maybeErrors:Array<DelitllfyError>;
	private var config:DelitllfyConfig;
	
	public inline function new (array:LitllArray<Litll>, index:Int, config:DelitllfyConfig)
	{
		this.config = config;
		this.array = array;
		this.index = index;
		
		error = Maybe.none();
		maybeErrors = [];
	}
    
	public function nextValue():Option<Litll>
    {
		return if (array.data.length <= index)
		{
			Option.None;
		}
        else
        {
            Option.Some(array.data[index]);
        }
    }
    
    private inline function matchNext(match:Litll->Bool):Bool
    {
        return if (array.data.length <= index)
		{
			false;
		}
        else
        {
            match(array.data[index]);
        }
    }
    
    public inline function readRest<T>(process:ProcessFunction<T>, match:Litll->Bool):Result<Array<T>, DelitllfyError> 
	{
		var array = [];
		var result = null;
		
		while (true)
		{
			if (matchNext(match))
			{
                switch (readData(process))
                {
                    case Result.Ok(data):
                        array.push(data);
                        
                    case Result.Err(error):
                        result = Result.Err(error);
                        break;
                }
			}
            else
            {
                result = Result.Ok(array);
                break;
            }
		}
        
        return result;
	}
    
    public inline function readOptional<T>(process:ProcessFunction<T>, match:Litll->Bool):Result<Option<T>, DelitllfyError> 
	{
        return if (matchNext(match))
        {
            switch (readData(process))
            {
                case Result.Ok(data):
                    Result.Ok(Option.Some(data));
                    
                case Result.Err(error):
                    Result.Err(error);
            }
        }
        else
        {
            Result.Ok(Option.None);
        }
	}
    
	public inline function readWithDefault<T>(process:ProcessFunction<T>, match:Litll->Bool, defaultValue:T):Result<T, DelitllfyError>
	{
        return if (matchNext(match))
        {
            switch (readData(process))
            {
                case Result.Ok(data):
                    Result.Ok(data);
                    
                case Result.Err(error):
                    Result.Err(error);
            }
        }
        else
        {
            Result.Ok(defaultValue);
        }
	}
    
	public inline function read<T>(process:ProcessFunction<T>):Result<T, DelitllfyError>
	{
		return switch (readData(process))
		{
			case Result.Ok(data):
				Result.Ok(data);
				
			case Result.Err(error):
				createErrorResult(error);
		}
	}
	
    public function readLabel(string:String):Result<Bool, DelitllfyError>
    {
        index++;
        return switch (array.data[index - 1])
        {
            case Litll.Str(data) if (data.data == string):
                Result.Ok(true);
                
            case _:
                createErrorResult(DelitllfyError.ofLitll(array.data[index - 1], DelitllfyErrorKind.UnmatchedLabel(string)));
        }
    }
    
	private function createErrorResult<T>(error:DelitllfyError):Result<T, DelitllfyError>
	{
		maybeErrors.iter(error.maybeCauses.push);
		maybeErrors = [];
		
		return if (config.persevering)
		{
			addFatalError(error);
			Result.Ok(null);
		}
		else
		{
			Result.Err(error);
		}
	}

	
	private inline function readData<T>(process:ProcessFunction<T>):Result<T, DelitllfyError>
	{
		index++;
		
		if (array.data.length < index)
		{
			return Result.Err(createError(DelitllfyErrorKind.EndOfArray));
		}
		
		var context = new DelitllfyContext(array.data[index - 1], config);
		return switch (process(context))
		{
			case Result.Err(childError):
				Result.Err(childError);
				
			case Result.Ok(data):
				Result.Ok(data);
		}
	}

    @:deprecated
	public inline function close<T>(create:Void->T):Result<T, DelitllfyError>
	{
		if (index < array.data.length)
		{
			addFatalError(createError(DelitllfyErrorKind.TooLongArray));
		}
		
		return switch (error.toOption())
		{
			case Option.Some(error):
				Result.Err(error);
			
			case Option.None:
				Result.Ok(create());
		}
	}

	public inline function closeOrError<T>(?posInfos:PosInfos):Option<DelitllfyError>
	{
		if (index < array.data.length)
		{
			addFatalError(createError(DelitllfyErrorKind.TooLongArray));
		}
		
		return error.toOption();
	}
	
	private function createError(kind:DelitllfyErrorKind):DelitllfyError
	{
		var e = DelitllfyError.ofArray(array, index, kind, maybeErrors);
		maybeErrors = [];
		return e;
	}
	
	public function addFatalError(nextError:DelitllfyError):Void
	{
		switch (error.toOption())
		{
			case Option.Some(_error):
				_error.followings.push(nextError);
				
			case Option.None:
				error = Maybe.some(nextError);
		}
	}
}

private typedef ProcessFunction<T> = DelitllfyContext->Result<T, DelitllfyError>;

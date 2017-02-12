package litll.idl.delitllfy;

import haxe.PosInfos;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.core.parse.array.ArrayContext;
import litll.idl.delitllfy.DelitllfyError;
using Lambda;

class DelitllfyArrayContext
{
	private var array:LitllArray<Litll>;
	private var config:DelitllfyConfig;
	public var index:Int;
	public var length(get, never):Int;
    private inline function get_length():Int 
    {
        return array.length;
    }
    
	public inline function new (array:LitllArray<Litll>, index:Int, config:DelitllfyConfig)
	{
		this.config = config;
		this.array = array;
		this.index = index;
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

	public inline function read<T>(process:ProcessFunction<T>):Result<T, DelitllfyError>
	{
		return switch (readData(process))
		{
			case Result.Ok(data):
				Result.Ok(data);
				
			case Result.Err(error):
				Result.Err(error);
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
                Result.Err(DelitllfyError.ofLitll(array.data[index - 1], DelitllfyErrorKind.UnmatchedLabel(string)));
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
    
    public inline function readFixedInline<T>(fixedInlineProcess:InlineProcessFunction<T>, length:Int):Result<T, DelitllfyError>
    {
        var localContext = new DelitllfyArrayContext(
            array.slice(0, length), 
            index,
            config
        );
        
        return fixedInlineProcess(localContext);
    }
    
    public inline function readVariableInline<T>(variableInlineProcess:InlineProcessFunction<T>):Result<T, DelitllfyError>
    {
        return variableInlineProcess(this);
    }
    
    public inline function readVariableOptionalInline<T>(variableInlineProcess:InlineProcessFunction<T>, match:Litll->Bool):Result<Option<T>, DelitllfyError>
    {
        return if (matchNext(match))
        {
            switch (variableInlineProcess(this))
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
    
    public inline function readFixedOptionalInline<T>(fixedInlineProcess:InlineProcessFunction<T>, length:Int, match:Litll->Bool):Result<Option<T>, DelitllfyError>
    {
        return if (matchNext(match))
        {
            switch (readFixedInline(fixedInlineProcess, length))
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
        };
    }
    
    public inline function readVariableRestInline<T>(process:InlineProcessFunction<T>, match:Litll->Bool):Result<Array<T>, DelitllfyError> 
	{
		var array = [];
		var result = null;
		
		while (true)
		{
			if (matchNext(match))
			{
                switch (process(this))
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
    
    public inline function readFixedRestInline<T>(process:InlineProcessFunction<T>, length:Int, match:Litll->Bool):Result<Array<T>, DelitllfyError> 
	{
		var array = [];
		var result = null;
		
		while (true)
		{
			if (matchNext(match))
			{
                switch (readFixedInline(process, length))
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
    
	public inline function closeOrError<T>(?posInfos:PosInfos):Option<DelitllfyError>
	{
		return if (index < array.data.length)
		{
			Option.Some(createError(DelitllfyErrorKind.TooLongArray));
		}
		else
        {
            Option.None;
        }
	}
	
	private function createError(kind:DelitllfyErrorKind):DelitllfyError
	{
		return DelitllfyError.ofArray(array, index, kind);
	}
}

private typedef ProcessFunction<T> = DelitllfyContext->Result<T, DelitllfyError>;
private typedef InlineProcessFunction<T> = DelitllfyArrayContext->Result<T, DelitllfyError>;

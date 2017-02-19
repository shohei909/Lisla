package litll.idl.litll2entity;

import haxe.PosInfos;
import haxe.ds.Option;
import litll.core.Litll;
import litll.core.LitllArray;
import hxext.ds.Maybe;
import hxext.ds.Result;
import litll.core.parse.array.ArrayContext;
import litll.idl.litll2entity.error.LitllToEntityError;
import litll.idl.litll2entity.error.LitllToEntityErrorKind;
using Lambda;

class LitllToEntityArrayContext
{
	private var config:LitllToEntityConfig;
	public var index(default, null):Int;
	public var length(get, never):Int;
    private var array:LitllArray<Litll>;
	
    private inline function get_length():Int 
    {
        return array.length;
    }
    
	public inline function new (array:LitllArray<Litll>, index:Int, config:LitllToEntityConfig)
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
    
	private inline function readData<T>(process:ProcessFunction<T>):Result<T, LitllToEntityError>
	{
		index++;
		
		if (array.data.length < index)
		{
			return Result.Err(createError(LitllToEntityErrorKind.EndOfArray));
		}
		
		var context = new LitllToEntityContext(array.data[index - 1], config);
		return switch (process(context))
		{
			case Result.Err(childError):
				Result.Err(childError);
				
			case Result.Ok(data):
				Result.Ok(data);
		}
	}

	public inline function read<T>(process:ProcessFunction<T>):Result<T, LitllToEntityError>
	{
		return switch (readData(process))
		{
			case Result.Ok(data):
				Result.Ok(data);
				
			case Result.Err(error):
				Result.Err(error);
		}
	}
	
    public function readLabel(string:String):Result<Bool, LitllToEntityError>
    {
        index++;
        return switch (array.data[index - 1])
        {
            case Litll.Str(data) if (data.data == string):
                Result.Ok(true);
                
            case _:
                Result.Err(LitllToEntityError.ofLitll(array.data[index - 1], LitllToEntityErrorKind.UnmatchedLabel(string)));
        }
    }
    
    public inline function readRest<T>(process:ProcessFunction<T>, match:Litll->Bool):Result<Array<T>, LitllToEntityError> 
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
    
    public inline function readOptional<T>(process:ProcessFunction<T>, match:Litll->Bool):Result<Option<T>, LitllToEntityError> 
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
    
	public inline function readWithDefault<T>(process:ProcessFunction<T>, match:Litll->Bool, defaultValue:T):Result<T, LitllToEntityError>
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
    
    public inline function readFixedInline<T>(process:ProcessFunction<T>, end:Int):Result<T, LitllToEntityError>
    {
        var localContext = new LitllToEntityContext(
            Litll.Arr(array.slice(index, end)), 
            config
        );
        index = end;
        return process(localContext);
    }
    
    public inline function readVariableInline<T>(variableInlineProcess:InlineProcessFunction<T>):Result<T, LitllToEntityError>
    {
        return variableInlineProcess(this);
    }
    
    public inline function readVariableOptionalInline<T>(variableInlineProcess:InlineProcessFunction<T>, match:Litll->Bool):Result<Option<T>, LitllToEntityError>
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
    
    public inline function readFixedOptionalInline<T>(process:ProcessFunction<T>, end:Int, match:Litll->Bool):Result<Option<T>, LitllToEntityError>
    {
        return if (matchNext(match))
        {
            switch (readFixedInline(process, end))
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
    
    public inline function readVariableRestInline<T>(process:InlineProcessFunction<T>, match:Litll->Bool):Result<Array<T>, LitllToEntityError> 
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
    
    public inline function readFixedRestInline<T>(process:ProcessFunction<T>, end:Int, match:Litll->Bool):Result<Array<T>, LitllToEntityError> 
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
    
	public inline function closeOrError<T>(?posInfos:PosInfos):Option<LitllToEntityError>
	{
		return if (index < array.data.length)
		{
			Option.Some(createError(LitllToEntityErrorKind.TooLongArray));
		}
		else
        {
            Option.None;
        }
	}
	
	private function createError(kind:LitllToEntityErrorKind):LitllToEntityError
	{
		return LitllToEntityError.ofArray(array, index, kind);
	}
}

private typedef ProcessFunction<T> = LitllToEntityContext->Result<T, LitllToEntityError>;
private typedef InlineProcessFunction<T> = LitllToEntityArrayContext->Result<T, LitllToEntityError>;

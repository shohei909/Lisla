package lisla.idl.lisla2entity;

import haxe.PosInfos;
import haxe.ds.Option;
import lisla.core.Lisla;
import lisla.core.LislaArray;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.core.parse.array.ArrayContext;
import lisla.idl.lisla2entity.error.LislaToEntityError;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;
using Lambda;

class LislaToEntityArrayContext
{
	private var config:LislaToEntityConfig;
	public var index(default, null):Int;
	public var length(get, never):Int;
    private var array:LislaArray<Lisla>;
	
    private inline function get_length():Int 
    {
        return array.length;
    }
    
	public inline function new (array:LislaArray<Lisla>, index:Int, config:LislaToEntityConfig)
	{
		this.config = config;
		this.array = array;
		this.index = index;
	}
    
	public function nextValue():Option<Lisla>
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
    
    private inline function matchNext(match:Lisla->Bool):Bool
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
    
	private inline function readData<T>(process:ProcessFunction<T>):Result<T, LislaToEntityError>
	{
		index++;
		
		if (array.data.length < index)
		{
			return Result.Err(createError(LislaToEntityErrorKind.EndOfArray));
		}
		
		var context = new LislaToEntityContext(array.data[index - 1], config);
		return switch (process(context))
		{
			case Result.Err(childError):
				Result.Err(childError);
				
			case Result.Ok(data):
				Result.Ok(data);
		}
	}

	public inline function read<T>(process:ProcessFunction<T>):Result<T, LislaToEntityError>
	{
		return switch (readData(process))
		{
			case Result.Ok(data):
				Result.Ok(data);
				
			case Result.Err(error):
				Result.Err(error);
		}
	}
	
    public function readLabel(string:String):Result<Bool, LislaToEntityError>
    {
        index++;
        return switch (array.data[index - 1])
        {
            case Lisla.Str(data) if (data.data == string):
                Result.Ok(true);
                
            case _:
                Result.Err(LislaToEntityError.ofLisla(array.data[index - 1], LislaToEntityErrorKind.UnmatchedLabel(string)));
        }
    }
    
    public inline function readRest<T>(process:ProcessFunction<T>, match:Lisla->Bool):Result<Array<T>, LislaToEntityError> 
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
    
    public inline function readOptional<T>(process:ProcessFunction<T>, match:Lisla->Bool):Result<Option<T>, LislaToEntityError> 
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
    
	public inline function readWithDefault<T>(process:ProcessFunction<T>, match:Lisla->Bool, defaultValue:T):Result<T, LislaToEntityError>
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
    
    public inline function readFixedInline<T>(process:ProcessFunction<T>, end:Int):Result<T, LislaToEntityError>
    {
        var localContext = new LislaToEntityContext(
            Lisla.Arr(array.slice(index, end)), 
            config
        );
        index = end;
        return process(localContext);
    }
    
    public inline function readVariableInline<T>(variableInlineProcess:InlineProcessFunction<T>):Result<T, LislaToEntityError>
    {
        return variableInlineProcess(this);
    }
    
    public inline function readVariableOptionalInline<T>(variableInlineProcess:InlineProcessFunction<T>, match:Lisla->Bool):Result<Option<T>, LislaToEntityError>
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
    
    public inline function readFixedOptionalInline<T>(process:ProcessFunction<T>, end:Int, match:Lisla->Bool):Result<Option<T>, LislaToEntityError>
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
    
    public inline function readVariableRestInline<T>(process:InlineProcessFunction<T>, match:Lisla->Bool):Result<Array<T>, LislaToEntityError> 
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
    
    public inline function readFixedRestInline<T>(process:ProcessFunction<T>, end:Int, match:Lisla->Bool):Result<Array<T>, LislaToEntityError> 
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
    
	public inline function closeOrError<T>(?posInfos:PosInfos):Option<LislaToEntityError>
	{
		return if (index < array.data.length)
		{
			Option.Some(createError(LislaToEntityErrorKind.TooLongArray));
		}
		else
        {
            Option.None;
        }
	}
	
	private function createError(kind:LislaToEntityErrorKind):LislaToEntityError
	{
		return LislaToEntityError.ofArray(array, index, kind);
	}
}

private typedef ProcessFunction<T> = LislaToEntityContext->Result<T, LislaToEntityError>;
private typedef InlineProcessFunction<T> = LislaToEntityArrayContext->Result<T, LislaToEntityError>;

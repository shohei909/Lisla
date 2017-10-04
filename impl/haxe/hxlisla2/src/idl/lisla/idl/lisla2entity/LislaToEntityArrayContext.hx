package arraytree.idl.arraytree2entity;

import haxe.PosInfos;
import haxe.ds.Option;
import hxext.ds.Result;
import arraytree.data.meta.core.ArrayWithMetadata;
import arraytree.data.meta.core.Metadata;
import arraytree.data.tree.al.AlTree;
import arraytree.data.tree.al.AlTreeKind;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind;
using Lambda;

class ArrayTreeToEntityArrayContext
{
	private var config:ArrayTreeToEntityConfig;
	public var index(default, null):Int;
	public var length(get, never):Int;
    private var array:ArrayWithMetadata<AlTree<String>>;
	
    private inline function get_length():Int 
    {
        return array.data.length;
    }
    
    
	public inline function new (
        array:Array<AlTree<String>>, 
        // TODO: metadata
        index:Int, 
        config:ArrayTreeToEntityConfig
    )
	{
		this.config = config;
		this.array = new ArrayWithMetadata(array, new Metadata());
		this.index = index;
	}
    
	public function nextValue():Option<AlTree<String>>
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
    
    private inline function matchNext(match:AlTree<String>->Bool):Bool
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
    
	private inline function readData<T>(process:ProcessFunction<T>):Result<T, Array<ArrayTreeToEntityError>>
	{
		index++;
		
		if (array.data.length < index)
		{
			return Result.Error(createError(ArrayTreeToEntityErrorKind.EndOfArray));
		}
		
		var context = new ArrayTreeToEntityContext(array.data[index - 1], config);
		return switch (process(context))
		{
			case Result.Error(childError):
				Result.Error(childError);
				
			case Result.Ok(data):
				Result.Ok(data);
		}
	}

	public inline function read<T>(process:ProcessFunction<T>):Result<T, Array<ArrayTreeToEntityError>>
	{
		return switch (readData(process))
		{
			case Result.Ok(data):
				Result.Ok(data);
				
			case Result.Error(error):
				Result.Error(error);
		}
	}
	
    public function readLabel(string:String):Result<Bool, Array<ArrayTreeToEntityError>>
    {
        index++;
        return switch (array.data[index - 1].kind)
        {
            case AlTreeKind.Leaf(data) if (data == string):
                Result.Ok(true);
                
            case _:
                Result.Error([new ArrayTreeToEntityError(ArrayTreeToEntityErrorKind.UnmatchedLabel(string))]);
        }
    }
    
    public inline function readRest<T>(process:ProcessFunction<T>, match:AlTree<String>->Bool):Result<Array<T>, Array<ArrayTreeToEntityError>> 
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
                        
                    case Result.Error(error):
                        result = Result.Error(error);
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
    
    public inline function readOptional<T>(process:ProcessFunction<T>, match:AlTree<String>->Bool):Result<Option<T>, Array<ArrayTreeToEntityError>> 
	{
        return if (matchNext(match))
        {
            switch (readData(process))
            {
                case Result.Ok(data):
                    Result.Ok(Option.Some(data));
                    
                case Result.Error(error):
                    Result.Error(error);
            }
        }
        else
        {
            Result.Ok(Option.None);
        }
	}
    
	public inline function readWithDefault<T>(process:ProcessFunction<T>, match:AlTree<String>->Bool, defaultArrayTree:AlTree<String>):Result<T, Array<ArrayTreeToEntityError>>
	{
        return if (matchNext(match))
        {
            switch (readData(process))
            {
                case Result.Ok(data):
                    Result.Ok(data);
                    
                case Result.Error(error):
                    Result.Error(error);
            }
        }
        else
        {
            var context = new ArrayTreeToEntityContext(defaultArrayTree, config);
            process(context);
        }
	}
    
    public inline function readFixedInline<T>(process:ProcessFunction<T>, end:Int):Result<T, Array<ArrayTreeToEntityError>>
    {
        var localContext = new ArrayTreeToEntityContext(
            new AlTree(AlTreeKind.Arr(array.data.slice(index, end)), array.metadata), 
            config
        );
        index = end;
        return process(localContext);
    }
    
    public inline function readVariableInline<T>(variableInlineProcess:InlineProcessFunction<T>):Result<T, Array<ArrayTreeToEntityError>>
    {
        return variableInlineProcess(this);
    }
    
    public inline function readVariableOptionalInline<T>(variableInlineProcess:InlineProcessFunction<T>, match:AlTree<String>->Bool):Result<Option<T>, Array<ArrayTreeToEntityError>>
    {
        return if (matchNext(match))
        {
            switch (variableInlineProcess(this))
            {
                case Result.Ok(data):
                    Result.Ok(Option.Some(data));
                    
                case Result.Error(error):
                    Result.Error(error);
            }
        }
        else
        {
            Result.Ok(Option.None);
        }
    }
    
    public inline function readFixedOptionalInline<T>(process:ProcessFunction<T>, end:Int, match:AlTree<String>->Bool):Result<Option<T>, Array<ArrayTreeToEntityError>>
    {
        return if (matchNext(match))
        {
            switch (readFixedInline(process, end))
            {
                case Result.Ok(data):
                    Result.Ok(Option.Some(data));
                    
                case Result.Error(error):
                    Result.Error(error);
            }
        }
        else
        {
            Result.Ok(Option.None);
        };
    }
    
    public inline function readVariableRestInline<T>(process:InlineProcessFunction<T>, match:AlTree<String>->Bool):Result<Array<T>, Array<ArrayTreeToEntityError>> 
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
                        
                    case Result.Error(error):
                        result = Result.Error(error);
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
    
    public inline function readFixedRestInline<T>(process:ProcessFunction<T>, end:Int, match:AlTree<String>->Bool):Result<Array<T>, Array<ArrayTreeToEntityError>> 
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
                        
                    case Result.Error(error):
                        result = Result.Error(error);
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
    
	public inline function closeOrError<T>(?posInfos:PosInfos):Option<Array<ArrayTreeToEntityError>>
	{
		return if (index < array.data.length)
		{
			Option.Some(createError(ArrayTreeToEntityErrorKind.TooLongArray));
		}
		else
        {
            Option.None;
        }
	}
	
	private function createError(kind:ArrayTreeToEntityErrorKind):Array<ArrayTreeToEntityError>
	{
		return [new ArrayTreeToEntityError(kind)];
	}
}

private typedef ProcessFunction<T> = ArrayTreeToEntityContext->Result<T, Array<ArrayTreeToEntityError>>;
private typedef InlineProcessFunction<T> = ArrayTreeToEntityArrayContext->Result<T, Array<ArrayTreeToEntityError>>;

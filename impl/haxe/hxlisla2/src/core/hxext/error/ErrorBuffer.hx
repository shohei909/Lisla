package hxext.error;
import hxext.ds.Maybe;
import hxext.ds.Result;
import hxext.error.ErrorBuffer;

class ErrorBuffer<Error> implements IErrorBuffer<Error>
{
    private var array:Array<Error>;
    
    public var length(get, never):Int;
    private inline function get_length():Int {
        return array.length;
    }
    
    public inline function new() 
    {
        array = [];
    }
    
    public inline function hasError():Bool
    {
        return array.length > 0;
    }
    
    public inline function toArray():Array<Error>
    {
        return array;
    }
    
    public inline function mapToArray<DestError>(errorFunc:Error->DestError):Array<DestError>
    {
        return [for (e in array) errorFunc(e)];
    }
    
    public inline function toResult<T>(okValue:T):Result<T, Array<Error>>
    {
        return if (hasError()) Result.Ok(okValue) else Result.Error(array);
    }
    
    public inline function mapToResult<T, DestError>(okValue:T, errorFunc:Error->DestError):Result<T, Array<DestError>>
    {
        return if (hasError()) Result.Ok(okValue) else Result.Error(mapToArray(errorFunc));
    }
    
    public inline function toMaybe():Maybe<Array<Error>>
    {
        return if (hasError()) Maybe.none() else Maybe.some(array);
    }
    
    public inline function mapToMaybe<DestError>(errorFunc:Error->DestError):Maybe<Array<DestError>>
    {
        return if (hasError()) Maybe.none() else Maybe.some(mapToArray(errorFunc));
    }
    
    public inline function push(error:Error):Void
    {
        array.push(error);
    }
    
    public inline function pushAll(errors:Array<Error>):Void
    {
        for (error in errors)
        {
            array.push(error);
        }
    }
    
    public inline function mapAndPushAll<SourceError>(errors:Array<SourceError>, errorFunc:SourceError->Error):Void
    {
        for (error in errors)
        {
            array.push(errorFunc(error));
        }
    }
    
    public inline function slice():ErrorBufferSlice<Error>
    {
        return new ErrorBufferSlice(this);
    }
    
}

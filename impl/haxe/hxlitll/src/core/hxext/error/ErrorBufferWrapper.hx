package hxext.error;
import hxext.error.IErrorBuffer;

class ErrorBufferWrapper<Error, InternalError> implements IErrorBuffer<Error>
{
    private var buffer:IErrorBuffer<Error>;
    private var convert:Error->InternalError;
    
    public var length(get, never):Int;
    private inline function get_length():Int {
        return buffer.length;
    }
    
    public inline function new(buffer:IErrorBuffer<Error>, convert:Error->InternalError) 
    {
        this.buffer = buffer;
        this.convert = convert;
    }
    
    public inline function hasError():Bool 
    {
        return buffer.hasError();
    }
    
    public inline function push(error:Error):Void 
    {
        return buffer.push(convert(error));
    }
    
    public inline function pushAll(errors:Array<Error>):Void 
    {
        for (error in errors)
        {
            buffer.push(error);
        }
    }
    
    public inline function slice():ErrorBufferSlice
    {
        return new ErrorBufferSlice(this);
    }
}

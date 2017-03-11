package hxext.error;
import hxext.error.IErrorBuffer;

class ErrorBufferSlice<Error> implements IErrorBuffer<Error>
{
    private var buffer:IErrorBuffer<Error>;
    private var start:Int;
    
    public var length(get, never):Int;
    private inline function get_length():Int {
        return buffer.length - start;
    }
    
    public inline function new(buffer:IErrorBuffer<Error>) 
    {
        this.buffer = buffer;
        this.start = buffer.length;
    }

    public inline function hasError():Bool 
    {
        return length > 0;
    }
    
    public inline function push(error:Error):Void 
    {
        buffer.push(error);
    }
    
    public inline function pushAll(errors:Array<Error>):Void 
    {
        buffer.pushAll(errors);
    }
    
    public inline function slice():ErrorBufferSlice<Error>
    {
        return new ErrorBufferSlice(this);
    }
}

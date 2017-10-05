package hxext.error;
import hxext.ds.Maybe;

interface IErrorBuffer <Error>
{
    public var length(get, never):Int;
    
    public function hasError():Bool;
    public function push(error:Error):Void;
    public function pushAll(errors:Array<Error>):Void;
    public function slice():ErrorBufferSlice<Error>;
}

package lisla.data.meta.position;

class Range
{
    public var start(default, null):CodePointIndex;
    public var length(default, null):CodePointIndex;
    
    public var end(get, never):CodePointIndex;
    private function get_end():CodePointIndex 
    {
        return start + length;
    }
    
    private function new(start:CodePointIndex, length:CodePointIndex) 
    {
        this.start = start;
        this.length = length;
    }
    
    public static function createWithEnd(start:CodePointIndex, end:CodePointIndex):Range
    {
        return new Range(start, end - start);
    }
    
    public static function createWithLength(start:CodePointIndex, length:Int):Range
    {
        return new Range(start, new CodePointIndex(length));
    }
    
    public static function zero():Range
    {
        return new Range(new CodePointIndex(0), new CodePointIndex(0));
    }
    
    public function toString():String
    {
        return start + "-" + start + length;
    }
}

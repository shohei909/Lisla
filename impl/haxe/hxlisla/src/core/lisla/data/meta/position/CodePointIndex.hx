package lisla.data.meta.position;

abstract CodePointIndex(Int) to Int
{
    public function new (value:Int)
    {
        this = value;
    }
    
    @:op(A + B) 
    private static function add(a:CodePointIndex, b:Int):CodePointIndex;
    
    @:op(A - B) 
    private static function subtract(a:CodePointIndex, b:Int):CodePointIndex;
    
    @:op(A < B)
    private static function lessThan(a:CodePointIndex, b:CodePointIndex):Bool;
    
    @:op(A > B)
    private static function graterThan(a:CodePointIndex, b:CodePointIndex):Bool;
    
    @:op(A <= B)
    private static function lessThanOrEquals(a:CodePointIndex, b:CodePointIndex):Bool;
    
    @:op(A >= B)
    private static function graterThanOrEquals(a:CodePointIndex, b:CodePointIndex):Bool;
    
    @:op(A == B)
    private static function equals(a:CodePointIndex, b:CodePointIndex):Bool;
}

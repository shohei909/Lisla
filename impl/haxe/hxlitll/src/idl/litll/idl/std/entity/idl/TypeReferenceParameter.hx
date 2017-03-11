package litll.idl.std.entity.idl;

import haxe.ds.Option;
import litll.core.Litll;
import hxext.ds.Maybe;

class TypeReferenceParameter
{
	public var value(default, null):Litll;
	public var processedValue:Maybe<TypeReferenceParameterKind>;
	
	public function new(value:Litll) 
	{
        this.value = value;
		this.processedValue = Maybe.none();
    }
    
    public function toString():String
    {
        // TODO: write litll
        return Std.string(value);
    }
}

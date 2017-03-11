package lisla.idl.std.entity.idl;

import haxe.ds.Option;
import lisla.core.Lisla;
import hxext.ds.Maybe;

class TypeReferenceParameter
{
	public var value(default, null):Lisla;
	public var processedValue:Maybe<TypeReferenceParameterKind>;
	
	public function new(value:Lisla) 
	{
        this.value = value;
		this.processedValue = Maybe.none();
    }
    
    public function toString():String
    {
        // TODO: write lisla
        return Std.string(value);
    }
}

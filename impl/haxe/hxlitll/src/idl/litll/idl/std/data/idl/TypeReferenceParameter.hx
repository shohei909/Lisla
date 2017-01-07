package litll.idl.std.data.idl;

import haxe.ds.Option;
import litll.core.Litll;
import litll.core.ds.Maybe;

class TypeReferenceParameter
{
	public var value(default, null):Litll;
	public var processedValue:Maybe<TypeReferenceParameterKind>;
	
	public function new(value:Litll) 
	{
        this.value = value;
		this.processedValue = Maybe.none();
    }
}

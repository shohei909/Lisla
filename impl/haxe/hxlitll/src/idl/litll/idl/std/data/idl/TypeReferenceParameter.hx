package litll.idl.std.data.idl;

import haxe.ds.Option;
import litll.core.Litll;

class TypeReferenceParameter
{
	public var value(default, null):Litll;
	public var processedValue:Option<TypeReferenceParameterKind>;
	
	public function new(value:Litll) 
	{
        this.value = value;
		this.processedValue = Option.None;
    }
}

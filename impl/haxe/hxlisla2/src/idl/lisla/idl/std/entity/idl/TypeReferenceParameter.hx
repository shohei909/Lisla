package lisla.idl.std.entity.idl;

import haxe.ds.Option;
import lisla.data.tree.al.AlTree;
import hxext.ds.Maybe;

class TypeReferenceParameter
{
	public var value(default, null):AlTree<String>;
	public var processedValue:Maybe<TypeReferenceParameterKind>;
	
	public function new(value:AlTree<String>) 
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

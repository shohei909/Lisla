package sora.idl.std.data.idl;
import haxe.ds.Option;
import sora.core.Sora;
import sora.idl.std.data.core.SoraOption;

class Argument
{
	public var name(default, null):ArgumentName;
	public var type(default, null):TypeReference;
	public var defaultValue(default, null):SoraOption<Sora>;
	
	public function new(name:ArgumentName, type:TypeReference, defaultValue:SoraOption<Sora>) 
	{
		this.name = name;
		this.type = type;
		this.defaultValue = defaultValue;
	}
}

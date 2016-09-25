package litll.idl.std.data.idl;
import litll.core.ds.Result;
import litll.core.string.IdentifierTools;

abstract EnumConstructorName(String) 
{
	public function new (string:String)
	{
		this = string;
	}
	
	public function toString():String
	{
		return this;
	}
	
	public function toPascalCase():Result<String, String>
	{
		return IdentifierTools.toPascalCase(this);
	}
}

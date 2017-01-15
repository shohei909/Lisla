package litll.idl.std.data.idl;
import litll.core.LitllString;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.core.string.IdentifierTools;

@:forward(tag)
abstract EnumConstructorName(LitllString) 
{
	public function new (string:LitllString)
	{
		this = string;
	}
	
	public function toString():String
	{
		return this.data;
	}
	
	public function toPascalCase():Result<String, String>
	{
		return IdentifierTools.toPascalCase(this.data);
	}
}

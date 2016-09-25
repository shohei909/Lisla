package;
import cases.IdlTest;
import cases.ParseTest;
import nanotest.NanoTestRunner;

class TestIdl
{
	public static var IDL_DIRECTORY:String = "../../../data/idl";
	
	public static function main():Void
	{
		var runner = new NanoTestRunner();
		runner.add(new ParseTest());
		runner.add(new IdlTest());
		runner.run();
	}
}

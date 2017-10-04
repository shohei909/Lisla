package;
import cases.IdlTest;
import cases.ParseTest;
import arraytree.project.FilePathFromProjectRoot;
import nanotest.NanoTestRunner;

class TestIdl
{
	public static var IDL_DIRECTORY = new FilePathFromProjectRoot("data/idl");
	
	public static function main():Void
	{
		var runner = new NanoTestRunner();
        runner.add(new ParseTest());
		runner.add(new IdlTest());
		runner.run();
	}
}

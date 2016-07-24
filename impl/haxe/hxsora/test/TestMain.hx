package;
import cases.ParseTest;
import format.sora.parser.Parser;
import nanotest.NanoTestRunner;

/**
 * ...
 * @author shohei909
 */
class TestMain
{
	public static function main():Void
	{
		var runner = new NanoTestRunner();
		runner.add(new ParseTest());
	}
}
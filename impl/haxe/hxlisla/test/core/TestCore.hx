package;

import cases.ParseTest;
import nanotest.NanoTestRunner;

/**
 * ...
 */
class TestCore
{
	public static var ASSET_ROOT:String = "../../../data/test_case/lisla";
	public static var BASIC_DIRECTORY:String = ASSET_ROOT + "/basic";
	public static var INVALID_NONFATAL_DIRECTORY:String = ASSET_ROOT + "/advanced/invalid/nonfatal";
	
	public static function main():Void
	{
		var runner = new NanoTestRunner();
		runner.add(new ParseTest());
		runner.run();
	}
}

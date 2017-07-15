package;

import cases.ParseTest;
import lisla.data.meta.position.FilePathFromProjectRoot;
import lisla.project.ProjectRootDirectory;
import nanotest.NanoTestRunner;

/**
 * ...
 */
class TestCore
{
    public static var PROJECT_ROOT               = new ProjectRootDirectory("../../../");
	public static var ASSET_ROOT                 = new FilePathFromProjectRoot("data/test_case/lisla");
	public static var BASIC_DIRECTORY            = new FilePathFromProjectRoot(ASSET_ROOT + "/basic");
	public static var INVALID_NONFATAL_DIRECTORY = new FilePathFromProjectRoot(ASSET_ROOT + "/advanced/invalid/nonfatal");
	
	public static function main():Void
	{
		var runner = new NanoTestRunner();
		runner.add(new ParseTest());
		runner.run();
	}
}

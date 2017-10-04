package;

import cases.ParseTest;
import cases.TemplateTest;
import arraytree.project.LocalPath;
import arraytree.project.ProjectRootDirectory;
import nanotest.NanoTestRunner;

/**
 * ...
 */
class TestCore
{
    public static var PROJECT_ROOT               = new ProjectRootDirectory("../../../");
	public static var ASSET_ROOT                 = new LocalPath("data/test_case/arraytree");
	public static var BASIC_DIRECTORY            = new LocalPath(ASSET_ROOT + "/basic");
	public static var INVALID_NONFATAL_DIRECTORY = new LocalPath(ASSET_ROOT + "/advanced/invalid/nonfatal");
	public static var TEMPLATE_DIRECTORY         = new LocalPath(ASSET_ROOT + "/advanced/template");
	
	public static function main():Void
	{
		var runner = new NanoTestRunner();
		runner.add(new ParseTest());
		runner.add(new TemplateTest());
		runner.run();
	}
}

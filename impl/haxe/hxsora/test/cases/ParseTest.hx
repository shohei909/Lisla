package cases;
import format.sora.data.Sora;
import format.sora.data.SoraArray;
import format.sora.data.SoraString;
import format.sora.parser.Parser;
import haxe.Json;
import haxe.PosInfos;
import nanotest.NanoTestCase;
import sys.FileSystem;
import sys.io.File;

class ParseTest extends SoraTestCase
{	
	public function new() 
	{
		super();
	}
	
	public function testSuccess():Void
	{
		for (file in FileSystem.readDirectory(TestMain.BASIC_DIRECTORY))
		{
			if (StringTools.endsWith(file, ".sora"))
			{
				var content = File.getContent(TestMain.BASIC_DIRECTORY + "/" + file);
				var caseData = Parser.run(content);
				switch (caseData.data)
				{
					case [Sora.Str(sora), Sora.Str(json)]:
						assertSoraArray(Parser.run(sora.data), Json.parse(json.data), '($file)');
						
					case _:
						fail("test case data must be [sora, json]");
				}
			}
		}
	}
	
	public function testFailure():Void
	{
		for (file in FileSystem.readDirectory(TestMain.INVALID_NONFATAL_DIRECTORY))
		{
			if (StringTools.endsWith(file, ".sora"))
			{
				var content = File.getContent(TestMain.INVALID_NONFATAL_DIRECTORY + "/" + file);
				assertThrows(Parser.run.bind(content)).label(file);
			}
		}
	}
}
package cases;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.LitllString;
import hxext.ds.Result;
import litll.core.parse.Parser;
import haxe.Json;
import haxe.PosInfos;
import nanotest.NanoTestCase;
import sys.FileSystem;
import sys.io.File;

class ParseTest extends LitllTestCase
{	
	public function new() 
	{
		super();
	}
	
	public function testSuccess():Void
	{
		for (file in FileSystem.readDirectory(TestCore.BASIC_DIRECTORY))
		{
			if (StringTools.endsWith(file, ".litll"))
			{
				var content = File.getContent(TestCore.BASIC_DIRECTORY + "/" + file);
				var caseData = switch (Parser.run(content))
				{
					case Result.Ok(data):
						data;
						
					case Result.Err(error):
						fail("failed to parse file:  \n" + error).label(file);
						continue;
				}
				
				switch (caseData.data)
				{
					case [Litll.Str(litll), Litll.Str(json)]:
						var litllData = switch (Parser.run(litll.data))
						{
							case Result.Ok(data):
								data;
								
							case Result.Err(error):
								fail("failed to parse file: \n" + error).label(file);
								continue;
						}
						
						assertLitllArray(litllData, Json.parse(json.data), file);
						
					case _:
						fail("test case data must be [litll, json]").label(file);
				}
			}
		}
	}
	
	public function testFailure():Void
	{
		for (file in FileSystem.readDirectory(TestCore.INVALID_NONFATAL_DIRECTORY))
		{
			if (StringTools.endsWith(file, ".litll"))
			{
				var content = File.getContent(TestCore.INVALID_NONFATAL_DIRECTORY + "/" + file);
				switch (Parser.run(content))
				{
					case Result.Ok(_):
						fail("paser must be fail.").label(file);
						
					case Result.Err(error):
						success();
				}
			}
		}
	}
}
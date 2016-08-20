package cases;
import sora.core.Sora;
import sora.core.SoraArray;
import sora.core.SoraString;
import sora.core.ds.Result;
import sora.core.parse.Parser;
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
		for (file in FileSystem.readDirectory(TestCore.BASIC_DIRECTORY))
		{
			if (StringTools.endsWith(file, ".sora"))
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
					case [Sora.Str(sora), Sora.Str(json)]:
						var soraData = switch (Parser.run(sora.data))
						{
							case Result.Ok(data):
								data;
								
							case Result.Err(error):
								fail("failed to parse file: \n" + error).label(file);
								continue;
						}
						
						assertSoraArray(soraData, Json.parse(json.data), file);
						
					case _:
						fail("test case data must be [sora, json]").label(file);
				}
			}
		}
	}
	
	public function testFailure():Void
	{
		for (file in FileSystem.readDirectory(TestCore.INVALID_NONFATAL_DIRECTORY))
		{
			if (StringTools.endsWith(file, ".sora"))
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
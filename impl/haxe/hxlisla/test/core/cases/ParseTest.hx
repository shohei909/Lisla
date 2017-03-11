package cases;
import lisla.core.Lisla;
import lisla.core.LislaArray;
import lisla.core.LislaString;
import hxext.ds.Result;
import lisla.core.parse.Parser;
import haxe.Json;
import haxe.PosInfos;
import nanotest.NanoTestCase;
import sys.FileSystem;
import sys.io.File;

class ParseTest extends LislaTestCase
{	
	public function new() 
	{
		super();
	}
	
	public function testSuccess():Void
	{
		for (file in FileSystem.readDirectory(TestCore.BASIC_DIRECTORY))
		{
			if (StringTools.endsWith(file, ".lisla"))
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
					case [Lisla.Str(lisla), Lisla.Str(json)]:
						var lislaData = switch (Parser.run(lisla.data))
						{
							case Result.Ok(data):
								data;
								
							case Result.Err(error):
								fail("failed to parse file: \n" + error).label(file);
								continue;
						}
						
						assertLislaArray(lislaData, Json.parse(json.data), file);
						
					case _:
						fail("test case data must be [lisla, json]").label(file);
				}
			}
		}
	}
	
	public function testFailure():Void
	{
		for (file in FileSystem.readDirectory(TestCore.INVALID_NONFATAL_DIRECTORY))
		{
			if (StringTools.endsWith(file, ".lisla"))
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
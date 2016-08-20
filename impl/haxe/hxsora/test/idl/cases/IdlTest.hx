package cases;
import SoraTestCase;
import TestCore;
import file.FileTools;
import sora.core.SoraArray;
import sora.core.ds.Result;
import sora.idl.std.desoralize.idl.IdlDesoralizer;
import sora.core.parse.Parser;
import sys.io.File;

class IdlTest extends SoraTestCase
{
	public function testDesoralize():Void
	{
		for (file in FileTools.readRecursively(TestIdl.IDL_DIRECTORY))
		{
			if (StringTools.endsWith(file, ".sora"))
			{
				var content = File.getContent(TestIdl.IDL_DIRECTORY+ "/" + file);
				var caseData = switch (Parser.run(content))
				{
					case Result.Ok(data):
						data;
						
					case Result.Err(error):
						fail("failed to parse file:  \n" + error).label(file);
						continue;
				}
				
				var idl = switch (IdlDesoralizer.run(caseData))
				{
					case Result.Ok(data):
						data;
						
					case Result.Err(error):
						fail("failed to desoralize file:  \n" + error).label(file);
						continue;
				}
			}
		}
	}
}

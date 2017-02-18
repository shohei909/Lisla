package cases;
import LitllTestCase;
import file.FileTools;
import litll.core.ds.Result;
import litll.core.parse.Parser;
import litll.idl.litll2backend.LitllToBackend;
import litll.idl.std.litll2backend.idl.IdlLitllToBackend;
import sys.io.File;

class IdlTest extends LitllTestCase
{
	public function testLitllToBackend():Void
	{
		for (file in FileTools.readRecursively(TestIdl.IDL_DIRECTORY))
		{
			if (StringTools.endsWith(file, ".idl.litll"))
			{
				var content = File.getContent(TestIdl.IDL_DIRECTORY + "/" + file);
				var caseData = switch (Parser.run(content))
				{
					case Result.Ok(data):
						data;
						
					case Result.Err(error):
						fail("failed to parse file:  \n" + error).label(file);
						continue;
				}
				
				var idl = switch (LitllToBackend.run(IdlLitllToBackend, caseData))
				{
					case Result.Ok(data):
						data;
						
					case Result.Err(error):
						fail("failed to litllToBackend file:  \n" + error).label(file);
						continue;
				}
			}
		}
	}
}

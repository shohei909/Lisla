package cases;
import LitllTestCase;
import TestCore;
import file.FileTools;
import litll.core.LitllArray;
import litll.core.ds.Result;
import litll.idl.delitllfy.Delitllfier;
import litll.idl.std.delitllfy.idl.IdlDelitllfier;
import litll.core.parse.Parser;
import sys.io.File;

class IdlTest extends LitllTestCase
{
	public function testDelitllfy():Void
	{
		for (file in FileTools.readRecursively(TestIdl.IDL_DIRECTORY))
		{
			if (StringTools.endsWith(file, ".idl.litll"))
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
				
				var idl = switch (Delitllfier.run(IdlDelitllfier.process, caseData))
				{
					case Result.Ok(data):
						data;
						
					case Result.Err(error):
						fail("failed to delitllfy file:  \n" + error).label(file);
						continue;
				}
			}
		}
	}
}

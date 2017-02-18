package cases;
import LitllTestCase;
import file.FileTools;
import hxext.ds.Result;
import litll.core.parse.Parser;
import litll.idl.litll2entity.LitllToEntityRunner;
import litll.idl.std.litll2entity.idl.IdlLitllToEntity;
import sys.io.File;

class IdlTest extends LitllTestCase
{
	public function testLitllToEntity():Void
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
				
				var idl = switch (LitllToEntityRunner.run(IdlLitllToEntity, caseData))
				{
					case Result.Ok(data):
						data;
						
					case Result.Err(error):
						fail("failed to litllToEntity file:  \n" + error).label(file);
						continue;
				}
			}
		}
	}
}

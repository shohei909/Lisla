package cases;
import LislaTestCase;
import file.FileTools;
import hxext.ds.Result;
import lisla.core.parse.Parser;
import lisla.idl.lisla2entity.LislaToEntityRunner;
import lisla.idl.std.lisla2entity.idl.IdlLislaToEntity;
import sys.io.File;

class IdlTest extends LislaTestCase
{
	public function testLislaToEntity():Void
	{
    	for (file in FileTools.readRecursively(TestIdl.IDL_DIRECTORY))
		{
			if (StringTools.endsWith(file, ".idl.lisla"))
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
				
				var idl = switch (LislaToEntityRunner.run(IdlLislaToEntity, caseData))
				{
					case Result.Ok(data):
						data;
						
					case Result.Err(error):
						fail("failed to lislaToEntity file:  \n" + error).label(file);
						continue;
				}
			}
		}
	}
}

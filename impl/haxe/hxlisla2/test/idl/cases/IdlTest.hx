package cases;
import hxext.ds.Result;
import lisla.idl.data.IdlRepository.TypeRepository;
import lisla.parse.Printer;
import lisla.project.ProjectRootDirectory;

class IdlTest extends LislaTestCase
{
    private var rootDirectory:ProjectRootDirectory;
    public function new() 
	{
		super();
        rootDirectory = TestCore.PROJECT_ROOT;
	}
    
	public function testLislaToEntity():Void
	{
        var typeRepository = new TypeRepository(rootDirectory, TestIdl.IDL_DIRECTORY);
        
    	for (filePath in rootProject.searchFiles(TestIdl.IDL_DIRECTORY, ".idl.lisla"))
		{
            var content = rootDirectory.getContent(filePath);
            var idlData = switch (Printer.parse(content))
            {
                case Result.Ok(data):
                    data;
                    
                case Result.Error(error):
                    fail("failed to parse file:  \n" + error).label(file);
                    continue;
            }
            
            var idlData = 
		}
	}
}

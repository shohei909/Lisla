package cases;
import haxe.Json;
import hxext.ds.Result;
import lisla.data.tree.array.ArrayTreeKind;
import lisla.error.core.ErrorStringfier.ErrorStringifier;
import lisla.parse.Parser;
import lisla.project.ProjectRootDirectory;


class ParseTest extends LislaTestCase
{	
    private var rootDirectory:ProjectRootDirectory;
    
	public function new() 
	{
		super();
        rootDirectory = TestCore.PROJECT_ROOT;
	}
	
	public function testSuccess():Void
	{
		for (filePath in rootDirectory.searchFiles(TestCore.BASIC_DIRECTORY, ".lisla"))
		{
            var content = rootDirectory.getContent(filePath);
            
            var caseDocument = switch (Parser.parse(content))
            {
                case Result.Ok(data):
                    data;
                    
                case Result.Error(errorResult):
                    var sourceMap = errorResult.getSourceMap();
                    for (error in errorResult.errors)
                    {
                        var message = ErrorStringifier.fromErrorInFile(filePath, sourceMap, error);
                        fail("failed to parse case file: " + message).label(filePath);
                    }
                    continue;
            }
            
            switch [caseDocument.data[0].kind, caseDocument.data[1].kind]
            {
                case [ArrayTreeKind.Leaf(arrayTree), ArrayTreeKind.Leaf(json)]:				
                    var arrayTreeDocument = switch (Parser.parse(arrayTree))
                    {
                        case Result.Ok(_document):
                            _document;
                            
                        case Result.Error(errorResult):
                            var caseSourceMap = caseDocument.getSourceMap();
                            var sourceMap = caseSourceMap.localize(errorResult.getSourceMap());
                            
                            for (error in errorResult.errors)
                            {
                                var message = ErrorStringifier.fromErrorInFile(filePath, sourceMap, error);
                                fail("failed to parse input: " + message).label(filePath);
                            }
                            continue;
                    }
            
                    assertArray(arrayTreeDocument.data, Json.parse(json), filePath);
                    
                case _:
                    fail("test case data must be [lisla, json]").label(filePath);
            }
		}
	}
	
	public function testFailure():Void
	{
		for (filePath in rootDirectory.searchFiles(TestCore.INVALID_NONFATAL_DIRECTORY, ".lisla"))
		{
            var content = rootDirectory.getContent(filePath);
            switch (Parser.parse(content))
            {
                case Result.Ok(_):
                    fail("paser must be fail.").label(filePath);
                    
                case Result.Error(errors):
                    success();
            }
		}
	}
}
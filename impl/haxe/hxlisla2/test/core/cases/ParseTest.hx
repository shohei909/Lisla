package cases;
import haxe.Json;
import haxe.ds.Option;
import hxext.ds.Result;
import lisla.data.meta.position.SourceMap;
import lisla.data.tree.al.AlTreeKind;
import lisla.error.core.ErrorStringifier;
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
            var pair = rootDirectory.makePair(filePath);
            
            var caseDocument = switch (Parser.parse(content))
            {
                case Result.Ok(data):
                    data;
                    
                case Result.Error(errors):
                    for (error in errors)
                    {
                        var message = ErrorStringifier.fromBlockErrorWithFilePath(error, pair);
                        fail("failed to parse case file: " + message).label(filePath);
                    }
                    continue;
            }
            
            switch [caseDocument.data[0].kind, caseDocument.data[1].kind]
            {
                case [AlTreeKind.Leaf(alTree), AlTreeKind.Leaf(json)]:				
                    var alTreeDocument = switch (Parser.parse(alTree))
                    {
                        case Result.Ok(_document):
                            _document;
                            
                        case Result.Error(errors):
                            for (error in errors)
                            {
                                var sourceMap = SourceMap.mergeOption(
                                    Option.Some(caseDocument.sourceMap),
                                    error.sourceMap
                                );
                                var message = ErrorStringifier.fromBlockErrorWithFilePath(error, pair);
                                fail("failed to parse input: " + message).label(filePath);
                            }
                            
                            continue;
                    }
            
                    assertArray(alTreeDocument.data, Json.parse(json), filePath);
                    
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
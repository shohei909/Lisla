package cases;
import haxe.Json;
import haxe.ds.Option;
import hxext.ds.Result;
import arraytree.data.meta.position.SourceMap;
import arraytree.data.tree.array.ArrayTreeKind;
import arraytree.parse.Parser;
import arraytree.project.ProjectRootDirectory;

class TemplateTest extends ArrayTreeTestCase
{
    private var rootDirectory:ProjectRootDirectory;
    
	public function new() 
	{
		super();
        rootDirectory = TestCore.PROJECT_ROOT;
	}

	public function test():Void
	{
		for (filePath in rootDirectory.searchFiles(TestCore.TEMPLATE_DIRECTORY, ".arraytree"))
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
                        var message = error.toString();
                        fail("failed to parse case file: " + message).label(filePath);
                    }
                    continue;
            }
            
            /*
            switch [caseDocument.data[0].kind, caseDocument.data[1].kind, caseDocument.data[2].kind]
            {
                case [ArrayTreeKind.Leaf(arrayTree), ArrayTreeKind.Arr(validData), ArrayTreeKind.Arr(invalidData)]:
                    var arrayTreeDocument = switch (Parser.parseTemplate(arrayTree))
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
                    
                    for (data in validData)
                    {
                        var map = data.getMap();
                        switch data[1].kind
                        {
                            case ArrayTreeKind.Leaf(json):
                                fail("TODO");
                                
                            case _:
                                fail("valid test case data must be [context, json]").label(filePath);
                        }
                    }

                    for (data in validData)
                    {
                        fail("TODO");
                    }

                case _:
                    fail("test case data must be [arraytree, valid cases, invalid cases]").label(filePath);
            }
            */
        }
	}
}
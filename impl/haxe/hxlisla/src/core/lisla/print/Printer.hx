package lisla.print;

import hxext.ds.Result;
import lisla.data.tree.array.ArrayTree;
import lisla.data.tree.array.ArrayTreeKind;
import lisla.error.parse.ArrayTreeParseError;
import lisla.parse.result.ArrayTreeParseResult;
import lisla.parse.result.ArrayTreeTemplateParseResult;
import lisla.print.PrintConfig;
import lisla.template.TemplateFinalizer;
using unifill.Unifill;

class Printer
{
    public static function printArrayTree(arrayTree:ArrayTree<String>, ?config:PrintConfig):String
    {
		if (config == null) 
		{
			config = new PrintConfig();
		}
        
        var string = "";
        switch (arrayTree.kind)
        {
            case ArrayTreeKind.Arr(array):
                string += "[";
                string += [for (tree in array) printArrayTree(tree, config)].join(" ");
                string += "]";
            
            case ArrayTreeKind.Leaf(string):
                var escapedString = string.split("\\").join("\\\\").split("\"").join("\\\"").split("\r").join("\\r").split("\n").join("\\n");
                string += '"$escapedString"';
        }
        
        return string;
    }
}

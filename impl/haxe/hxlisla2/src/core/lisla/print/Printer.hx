package lisla.print;

import hxext.ds.Result;
import lisla.data.tree.al.AlTree;
import lisla.data.tree.al.AlTreeKind;
import lisla.error.parse.AlTreeParseError;
import lisla.parse.result.AlTreeParseResult;
import lisla.parse.result.AlTreeTemplateParseResult;
import lisla.print.PrintConfig;
import lisla.template.TemplateFinalizer;
using unifill.Unifill;

class Printer
{
    public static function printAlTree(alTree:AlTree<String>, ?config:PrintConfig):String
    {
		if (config == null) 
		{
			config = new PrintConfig();
		}
        
        var string = "";
        switch (alTree.kind)
        {
            case AlTreeKind.Arr(array):
                string += "[";
                string += [for (tree in array) printAlTree(tree, config)].join(" ");
                string += "]";
            
            case AlTreeKind.Leaf(string):
                var escapedString = string.split("\\").join("\\\\").split("\"").join("\\\"").split("\r").join("\\r").split("\n").join("\\n");
                string += '"$escapedString"';
        }
        
        return string;
    }
}

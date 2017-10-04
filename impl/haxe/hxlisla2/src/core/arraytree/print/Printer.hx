package arraytree.print;

import hxext.ds.Result;
import arraytree.data.tree.array.ArrayTree;
import arraytree.data.tree.array.ArrayTreeKind;
import arraytree.error.parse.ArrayTreeParseError;
import arraytree.parse.result.ArrayTreeParseResult;
import arraytree.parse.result.ArrayTreeTemplateParseResult;
import arraytree.print.PrintConfig;
import arraytree.template.TemplateFinalizer;
using unifill.Unifill;

class Printer
{
    public static function printAlTree(alTree:ArrayTree<String>, ?config:PrintConfig):String
    {
		if (config == null) 
		{
			config = new PrintConfig();
		}
        
        var string = "";
        switch (alTree.kind)
        {
            case ArrayTreeKind.Arr(array):
                string += "[";
                string += [for (tree in array) printAlTree(tree, config)].join(" ");
                string += "]";
            
            case ArrayTreeKind.Leaf(string):
                var escapedString = string.split("\\").join("\\\\").split("\"").join("\\\"").split("\r").join("\\r").split("\n").join("\\n");
                string += '"$escapedString"';
        }
        
        return string;
    }
}

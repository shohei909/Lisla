package lisla.parse.string;
import lisla.data.leaf.template.TemplateLeaf;
import lisla.data.meta.core.Metadata;
import lisla.data.tree.array.ArrayTree;
import lisla.data.tree.array.ArrayTreeKind;

class QuotedStringArrayPair
{
    public var string:Array<QuotedStringLine>;
    public var trees:Array<ArrayTree<TemplateLeaf>>;
    public var tag:Metadata;

    public function new(string:Array<QuotedStringLine>, tag:Metadata)
    {
        this.string = string;
        this.trees = [];
        this.tag = tag;
    }
    
    public function pushArray(data:Array<ArrayTree<TemplateLeaf>>, metadata:Metadata):Void
    {
        var kind = ArrayTreeKind.Arr(data);
    	var arr = new ArrayTree<TemplateLeaf>(kind, metadata);
        trees.push(arr);
    }
}

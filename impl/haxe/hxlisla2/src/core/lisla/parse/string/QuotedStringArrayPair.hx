package lisla.parse.string;
import lisla.data.leaf.template.TemplateLeaf;
import lisla.data.meta.core.Metadata;
import lisla.data.tree.array.ArrayTree;
import lisla.data.tree.array.ArrayTreeKind;

class QuotedStringArrayPair
{
    public var string:Array<QuotedStringLine>;
    public var trees:Array<ArrayTree<TemplateLeaf>>;
    public var metadata:Metadata;

    public function new(string:Array<QuotedStringLine>, metadata:Metadata)
    {
        this.string = string;
        this.trees = [];
        this.metadata = metadata;
    }
    
    public function pushArray(data:Array<ArrayTree<TemplateLeaf>>, metadata:Metadata):Void
    {
        var kind = ArrayTreeKind.Arr(data);
    	var arr = new ArrayTree<TemplateLeaf>(kind, metadata);
        trees.push(arr);
    }
}

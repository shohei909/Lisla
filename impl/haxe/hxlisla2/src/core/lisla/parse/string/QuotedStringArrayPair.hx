package lisla.parse.string;
import lisla.data.leaf.template.TemplateLeaf;
import lisla.data.meta.core.Metadata;
import lisla.data.tree.al.AlTree;
import lisla.data.tree.al.AlTreeKind;

class QuotedStringArrayPair
{
    public var string:Array<QuotedStringLine>;
    public var trees:Array<AlTree<TemplateLeaf>>;
    public var metadata:Metadata;

    public function new(string:Array<QuotedStringLine>, metadata:Metadata)
    {
        this.string = string;
        this.trees = [];
        this.metadata = metadata;
    }
    
    public function pushArray(data:Array<AlTree<TemplateLeaf>>, metadata:Metadata):Void
    {
        var kind = AlTreeKind.Arr(data);
    	var arr = new AlTree<TemplateLeaf>(kind, metadata);
        trees.push(arr);
    }
}

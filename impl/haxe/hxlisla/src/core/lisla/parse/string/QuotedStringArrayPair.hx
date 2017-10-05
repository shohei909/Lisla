package lisla.parse.string;
import lisla.data.leaf.template.TemplateLeaf;
import lisla.data.meta.core.Tag;
import lisla.data.tree.array.ArrayTree;
import lisla.data.tree.array.ArrayTreeKind;

class QuotedStringArrayPair
{
    public var string:Array<QuotedStringLine>;
    public var trees:Array<ArrayTree<TemplateLeaf>>;
    public var tag:Tag;

    public function new(string:Array<QuotedStringLine>, tag:Tag)
    {
        this.string = string;
        this.trees = [];
        this.tag = tag;
    }
    
    public function pushArray(data:Array<ArrayTree<TemplateLeaf>>, tag:Tag):Void
    {
        var kind = ArrayTreeKind.Arr(data);
    	var arr = new ArrayTree<TemplateLeaf>(kind, tag);
        trees.push(arr);
    }
}

package lisla.parse.string;
import lisla.data.leaf.template.TemplateLeaf;
import lisla.data.meta.core.Tag;
import lisla.data.meta.core.WithTag;
import lisla.data.tree.array.ArrayTree;
import lisla.data.tree.array.ArrayTreeArray;

class QuotedStringArrayPair
{
    public var string:Array<QuotedStringLine>;
    public var trees:ArrayTreeArray<TemplateLeaf>;
    public var tag:Tag;

    public function new(string:Array<QuotedStringLine>, tag:Tag)
    {
        this.string = string;
        this.trees = [];
        this.tag = tag;
    }
    
    public function pushArray(data:ArrayTreeArray<TemplateLeaf>, tag:Tag):Void
    {
        var kind = ArrayTree.Arr(data);
    	var arr = new WithTag(kind, tag);
        trees.push(arr);
    }
}

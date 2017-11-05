package lisla.type.lisla.type;
import lisla.data.meta.core.WithTag;
import lisla.data.tree.array.StringArrayTree;

class ConstElement 
{
    public var name:WithTag<VariableName>;
    public var const:WithTag<StringArrayTree>;
    
    public function new(
        name:WithTag<VariableName>,
        const:WithTag<StringArrayTree>
    ) {
        this.name = name;
        this.const = const;
    }   
}

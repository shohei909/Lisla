package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;
import lisla.data.tree.array.StringArrayTree;
import lisla.idl.code.library.CodeVariableName;

class CodeConstElement 
{
    private var name:WithTag<CodeVariableName>;
    private var const:WithTag<StringArrayTree>;
    
    public function new(
        name:WithTag<CodeVariableName>,
        const:WithTag<StringArrayTree>
    ) {
        this.name = name;
        this.const = const;
    }   
}
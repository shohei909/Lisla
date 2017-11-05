package lisla.type.lisla.type;
import lisla.data.tree.array.ArrayTree;
import lisla.data.tree.array.StringArrayTree;

abstract TypeArgument(StringArrayTree) from StringArrayTree to StringArrayTree
{
    public function new(value:StringArrayTree)
    {
        this = value;
    }
}

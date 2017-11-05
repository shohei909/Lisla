package lisla.type.lisla.type;
import lisla.data.meta.core.WithTag;
import lisla.data.tree.array.StringArrayTree;
import lisla.type.core.Const;
import lisla.type.core.Tuple.Tuple1;

enum VarRule {  
    Default(value:Tuple1<StringArrayTree>);
    Optional;
    Repeated;
}

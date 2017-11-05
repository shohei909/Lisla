package lisla.type.lisla.type;
import haxe.ds.Option;
import lisla.data.meta.core.WithTag;

class TypeParameterDeclarationAttributes 
{
    public var rule:Option<WithTag<VarRule>>;
    public function new(
        rule:Option<WithTag<VarRule>>
    ) 
    {
        this.rule = rule;
    }    
}
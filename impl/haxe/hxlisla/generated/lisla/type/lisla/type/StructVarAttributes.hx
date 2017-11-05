package lisla.type.lisla.type;
import haxe.ds.Option;
import lisla.data.meta.core.WithTag;

class StructVarAttributes 
{
    public var rule:Option<WithTag<VarRule>>;
    public var nest:Option<WithTag<StructVarNest>>;
    public var tag:Option<WithTag<Int>>;
    
    public function new(
        rule:Option<WithTag<VarRule>>,
        nest:Option<WithTag<StructVarNest>>,
        tag:Option<WithTag<Int>>
    ) {
        this.rule = rule;
        this.nest = nest;
        this.tag = tag;        
    }
}
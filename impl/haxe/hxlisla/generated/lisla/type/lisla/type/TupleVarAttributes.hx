package lisla.type.lisla.type;
import haxe.ds.Option;
import lisla.data.meta.core.WithTag;

class TupleVarAttributes {
    public var rule:Option<WithTag<VarRule>>;
    public var nest:Option<WithTag<TupleVarNest>>;
    public var tag:Option<WithTag<Int>>;
    
    public function new(
        rule:Option<WithTag<VarRule>>,
        nest:Option<WithTag<TupleVarNest>>,
        tag:Option<WithTag<Int>>
    ) {
        this.rule = rule;
        this.nest = nest;
        this.tag = tag;
    }
    
    public static function empty():TupleVarAttributes
    {
        return new TupleVarAttributes(
            Option.None,
            Option.None,
            Option.None
        );
    }
}

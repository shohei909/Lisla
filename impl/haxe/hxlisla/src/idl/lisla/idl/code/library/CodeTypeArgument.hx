package lisla.idl.code.library;
import haxe.ds.Option;
import lisla.data.meta.core.WithTag;

enum CodeTypeArgument 
{
    Required(value:WithTag<CodeTypeArgumentElement>);
    Repeated(value:Array<WithTag<CodeTypeArgumentElement>>);
    Optional(value:Option<WithTag<CodeTypeArgumentElement>>);
}

package lisla.idl.code.library;
import hxext.ds.OrderedMap;
import lisla.data.meta.core.WithTag;
import lisla.type.core.LislaMap;

class CodeModule
{
    public var types:LislaMap<CodeTypeName, WithTag<CodeType>>;
    public function new(
        types:LislaMap<CodeTypeName, WithTag<CodeType>>
    )
    {
        this.types = types;
    }   
}

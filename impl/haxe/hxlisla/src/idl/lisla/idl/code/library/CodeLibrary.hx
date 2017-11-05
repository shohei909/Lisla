package lisla.idl.code.library;
import hxext.ds.OrderedMap;
import lisla.data.meta.core.WithTag;

class CodeLibrary
{
    public var types:OrderedMap<CodePackagePath, WithTag<CodeModule>>;
    public function new(
        types:OrderedMap<CodePackagePath, WithTag<CodeModule>>
    )
    {
        this.types = types;
    }
}

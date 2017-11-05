package lisla.idl.code.library;
import lisla.data.meta.core.WithTag;
import lisla.type.lisla.type.TypePath;

class CodeTypePath 
{
    public var idlPath:WithTag<TypePath>;
    public var codePath:WithTag<String>;

    public function new(
        idlPath:WithTag<TypePath>, 
        codePath:WithTag<String>
    ) 
    {
        this.codePath = codePath;
        this.idlPath = idlPath;
    }
}
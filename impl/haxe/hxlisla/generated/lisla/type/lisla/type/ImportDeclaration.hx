package lisla.type.lisla.type;
import haxe.ds.Option;
import lisla.data.meta.core.WithTag;
import lisla.type.lisla.type.ImportAsDeclaration;

class ImportDeclaration
{
    public var path:WithTag<TypePath>;
    public var newName:Option<WithTag<ImportAsDeclaration>>;
    
    public function new(path:WithTag<TypePath>, newName:Option<WithTag<ImportAsDeclaration>>)
    {
        this.path = path;
        this.newName = newName;
    }
}

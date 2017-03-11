package litll.idl.library;
import litll.idl.generator.output.EntityTypeInfomation;

class LibraryTypesData 
{
    public var library:Library;
    public var infomations:Array<EntityTypeInfomation>;
    
    public function new(library:Library, infomations:Array<EntityTypeInfomation>) 
    {
        this.library = library;
        this.infomations = infomations;
    }
}
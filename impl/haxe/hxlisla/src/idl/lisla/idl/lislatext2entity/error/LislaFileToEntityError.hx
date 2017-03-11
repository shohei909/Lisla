package lisla.idl.lislatext2entity.error;
import lisla.core.error.FileErrorSummary;

class LislaFileToEntityError
{
    public var file(default, null):String;
    public var kind(default, null):LislaFileToEntityErrorKind;
    
    public function new (file:String, kind:LislaFileToEntityErrorKind)
    {
        this.file = file;
        this.kind = kind;
    }
    
    public function getSummary():FileErrorSummary<LislaFileToEntityErrorKind>
    {
        return LislaFileToEntityErrorKindTools.getSummary(kind).withFile(file);
    }
}

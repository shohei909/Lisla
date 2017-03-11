package litll.idl.litlltext2entity.error;
import litll.core.error.FileErrorSummary;

class LitllFileToEntityError
{
    public var file(default, null):String;
    public var kind(default, null):LitllFileToEntityErrorKind;
    
    public function new (file:String, kind:LitllFileToEntityErrorKind)
    {
        this.file = file;
        this.kind = kind;
    }
    
    public function getSummary():FileErrorSummary<LitllFileToEntityErrorKind>
    {
        return LitllFileToEntityErrorKindTools.getSummary(kind).withFile(file);
    }
}

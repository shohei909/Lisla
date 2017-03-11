package litll.idl.generator.error;
import litll.core.error.FileErrorSummary;

class ReadIdlError
{
    public var file:String;
    public var kind:ReadIdlErrorKind;
    
    public function new (file:String, kind:ReadIdlErrorKind)
    {
        this.file = file;
        this.kind = kind;
    }
    
    public function getSummary():FileErrorSummary<ReadIdlErrorKind>
	{
        return ReadIdlErrorKindTools.getSummary(kind).withFile(file);
	}
}

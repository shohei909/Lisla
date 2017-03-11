package lisla.idl.generator.error;
import lisla.core.error.FileErrorSummary;

class LoadIdlError
{
    public var file:String;
    public var kind:LoadIdlErrorKind;
    
    public function new (file:String, kind:LoadIdlErrorKind)
    {
        this.file = file;
        this.kind = kind;
    }
    
    public function getSummary():FileErrorSummary<LoadIdlErrorKind>
	{
        return LoadIdlErrorKindTools.getSummary(kind).withFile(file);
	}
}

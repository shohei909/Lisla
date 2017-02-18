package litll.idl;
import litll.core.error.ErrorSummary;
import litll.core.error.FileErrorSummary;
import litll.core.error.LitllErrorSummary;
class FileError<ErrorKind>
{
    public var filePath(default, null):String;
    public var errorKind(default, null):ErrorKind;
    
    public function new(filePath:String, errorKind:ErrorKind) 
    {
        this.filePath = filePath;
        this.errorKind = errorKind;
    }
    
    public inline function getSummaryWithConvert(convert:ErrorKind->ErrorSummary):FileErrorSummary
    {
        return new FileErrorSummary(filePath, convert(errorKind));
    }
}

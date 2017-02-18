package litll.idl.generator.error;
import litll.core.error.FileErrorSummary;
class IdlReadError extends FileError<IdlReadErrorKind>
{	
    public function getSummary():FileErrorSummary
	{
        return getSummaryWithConvert(IdlReadErrorKindTools.getSummary);
	}
}

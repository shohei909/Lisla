package litll.idl.litlltext2entity.error;
import litll.core.error.ErrorSummary;
import litll.core.error.FileErrorSummary;
import litll.idl.FileError;

class LitllFileToEntityError extends FileError<LitllFileToEntityErrorKind>
{
    public function getSummary():FileErrorSummary
    {
        return getSummaryWithConvert(LitllFileToEntityErrorKindTools.getSummary);
    }
}

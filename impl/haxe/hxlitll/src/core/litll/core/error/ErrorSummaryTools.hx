package litll.core.error;

class ErrorSummaryTools 
{
    public static inline function summarize(errors:Iterable<{function getSummary():ErrorSummary;}>):Array<ErrorSummary>
    {
        return [for (e in errors) e.getSummary()];
    }   
}
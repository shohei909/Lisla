package litll.core.error;

class FileErrorSummary implements ErrorSummary
{
    public var filePath:String;
    public var summary:ErrorSummary;
    
    public function new(filePath:String, summary:ErrorSummary) 
    {
        this.filePath = filePath;
        this.summary = summary;
    }
    
    public function toString():String
    {
        return filePath + ": " + summary.toString();
    }
    
    public function toLitll():Litll
    {
        return Litll.Arr(
            new LitllArray(
                [
                    Litll.Str(new LitllString(filePath)),
                    summary.toLitll(),
                ]
            )
        );
    }
}

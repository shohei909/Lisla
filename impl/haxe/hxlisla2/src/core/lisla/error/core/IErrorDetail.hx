package lisla.error.core;

interface IErrorDetail extends IErrorDetailHolder
{
    public function getMessage():String;
    public function getErrorName():ErrorName;
}

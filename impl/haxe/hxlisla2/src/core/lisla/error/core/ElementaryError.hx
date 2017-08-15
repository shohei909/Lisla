package lisla.error.core;

interface ElementaryError extends ElementaryErrorHolder
{
    public function getMessage():String;
    public function getErrorName():ErrorName;    
}
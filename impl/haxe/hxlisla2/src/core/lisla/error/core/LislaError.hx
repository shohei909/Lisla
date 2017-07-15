package lisla.error.core;

interface LislaError
{
    public function toString():String;
    public function getErrorName():ErrorName;
}

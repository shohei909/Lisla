package lisla.error.exception;
import lisla.error.core.ErrorName;
import lisla.error.core.LislaError;

class FatalException implements LislaError
{
    public var name:String;
    public var factorClass:Class<Dynamic>;
    public var message:String;
    
    public function new(message:String, factorClass:Class<Dynamic>, name:String) 
    {
        this.message = message;
        this.factorClass = factorClass;
        this.name = name;
    }   
    
    
    public function toString():String 
    {
        return message;
    }
    
    public function getErrorName():ErrorName
    {
        return new ErrorName(Type.getClassName(factorClass) + "." + name);
    }
}

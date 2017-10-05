package lisla.error.exception;
import haxe.ds.Option;
import lisla.data.meta.position.Position;
import lisla.data.meta.position.Range;
import lisla.error.core.Error;
import lisla.error.core.ErrorName;
import lisla.error.core.IErrorDetail;
import lisla.error.core.IErrorDetailHolder;

class FatalException extends Error<FatalExceptionDetail>
{
    public function new(message:String, factorClass:Class<Dynamic>, name:String, position:Position)
    {
        super(
            new FatalExceptionDetail(message, factorClass, name),
            position
        );
    }
}

class FatalExceptionDetail implements IErrorDetail
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
    
    public function getDetail():IErrorDetail
    {
        return this;
    }
    
    public function getMessage():String
    {
        return message;
    }
    
    public function getErrorName():ErrorName
    {
        return ErrorName.fromClass(factorClass, name);
    }
}

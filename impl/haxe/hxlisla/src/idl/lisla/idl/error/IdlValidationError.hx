package lisla.idl.error;
import lisla.data.meta.position.Position;
import lisla.error.core.Error;
import lisla.error.core.ErrorName;
import lisla.error.core.IErrorDetail;

class IdlValidationError extends Error<IdlValidationErrorDetail>
{
    public function new(name:ErrorName, message:String, position:Position)
    {
        super(
            new IdlValidationErrorDetail(name, message), 
            position
        );
    }
}

class IdlValidationErrorDetail implements IErrorDetail
{
    public var name:ErrorName;
    public var message:String;
    
    public function new(name:ErrorName, message:String)
    {
        this.name = name;
        this.message = message;
    }
    
    public function getMessage():String 
    {
        return message;
    }
    
    public function getErrorName():ErrorName
    {
        return name;
    }
    
    public function getDetail():IErrorDetail
    {
        return this;
    }
}

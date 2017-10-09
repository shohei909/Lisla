package lisla.error.exception;
import haxe.PosInfos;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.data.meta.position.Position;
import lisla.data.meta.position.Range;
import lisla.error.core.Error;
import lisla.error.core.ErrorName;
import lisla.error.core.IErrorDetail;
import lisla.error.core.IErrorDetailHolder;

class FatalException extends Error<FatalExceptionDetail>
{
    public function new(message:String, name:String, position:Maybe<Position>, ?posInfos:PosInfos)
    {
        super(
            new FatalExceptionDetail(message, posInfos.className, name),
            position
        );
    }
}

class FatalExceptionDetail implements IErrorDetail
{
    public var name:String;
    public var factorClass:String;
    public var message:String;
    
    public function new(message:String, factorClass:String, name:String)
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
        return new ErrorName(factorClass + "." + name);
    }
}

package arraytree.error.exception;
import haxe.ds.Option;
import arraytree.data.meta.position.Position;
import arraytree.data.meta.position.Range;
import arraytree.error.core.Error;
import arraytree.error.core.ErrorName;
import arraytree.error.core.IErrorDetail;
import arraytree.error.core.IErrorDetailHolder;

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

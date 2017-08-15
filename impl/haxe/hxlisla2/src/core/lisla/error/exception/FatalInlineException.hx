package lisla.error.exception;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.error.core.ErrorName;
import lisla.error.core.InlineError;
import lisla.error.core.ElementaryError;

class FatalInlineException 
    implements InlineError
    implements ElementaryError
{
    public var name:String;
    public var factorClass:Class<Dynamic>;
    public var message:String;
    public var range:Option<Range>;
    
    public function new(message:String, factorClass:Class<Dynamic>, name:String, range:Option<Range>) 
    {
        this.message = message;
        this.factorClass = factorClass;
        this.name = name;
        this.range = range;
    }   
    
    public function getOptionRange():Option<Range> 
    {
        return range;
    }
    
    public function getMessage():String
    {
        return message;
    }
    
    public function getErrorName():ErrorName
    {
        return ErrorName.fromClass(factorClass, name);
    }
    
    public function getInlineError():InlineError 
    {
        return this;
    }
    
    public function getElementaryError():ElementaryError
    {
        return this;
    }
}

package lisla.type.standard.identifer;
import hxext.ds.Result;
import lisla.error.core.ErrorName;
import lisla.idl.error.IdlValidationError;

abstract LowerSnakeIdentifer(String)
{
    private static var ereg = ~/[a-z][a-z_]+/;
    public var value(get, never):String; 
    private function get_value():String {
        return this;
    }
    
    private function new(value:String) 
    {
        this = value;
    }
    
    @:from public static function from(value:String):LowerSnakeIdentifer {
        if (!ereg.match(value))
        {
            throw error(value);
        }
        return new LowerSnakeIdentifer(value);
    }
    
    public static function create(value:String):Result<LowerSnakeIdentifer, IdlValidationErrorDetail>
    {
        return if (!ereg.match(value))
        {
            Result.Error(error(value));
        } 
        else
        {
            Result.Ok(new LowerSnakeIdentifer(value));
        }
    }
    
    private static function error(value:String):IdlValidationErrorDetail
    {
        return new IdlValidationErrorDetail(
            new ErrorName("lisla.type.standard.identifer.LowerSnakeIdentifer.ValidationError"), 
            "'" + value + "' should be upper camel case."
        );
    }
}

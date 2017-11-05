package lisla.type.standard.identifer;
import hxext.ds.Result;
import lisla.error.core.ErrorName;
import lisla.idl.error.IdlValidationError;

abstract UpperCamelIdentifer(String) from String to String
{
    private static var ereg = ~/[A-Z][a-zA-Z]*/;
    public var value(get, never):String; 
    private function get_value():String {
        return this;
    }

    private function new(value:String) 
    {
        this = value;
    }
    
    @:from public static function from(value:String):UpperCamelIdentifer {
        if (!ereg.match(value))
        {
            throw error(value);
        }
        return new UpperCamelIdentifer(value);
    }
    
    public static function create(value:String):Result<UpperCamelIdentifer, IdlValidationErrorDetail>
    {
        return if (!ereg.match(value))
        {
            Result.Error(error(value));
        } 
        else
        {
            Result.Ok(new UpperCamelIdentifer(value));
        }
    }
    
    private static function error(value:String):IdlValidationErrorDetail
    {
        return new IdlValidationErrorDetail(
            new ErrorName("lisla.type.standard.identifer.UpperCamelIdentifer.ValidationError"), 
            "'" + value + "' should be upper camel case."
        );
    }
}

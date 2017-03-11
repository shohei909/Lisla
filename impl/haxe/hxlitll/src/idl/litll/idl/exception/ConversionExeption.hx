package lisla.idl.exception;
import lisla.idl.generator.error.LoadIdlError;

class ConversionExeption extends IdlException
{
    public function new(message:String, read:Array<LoadIdlError>) {
        super(message);
    }
}
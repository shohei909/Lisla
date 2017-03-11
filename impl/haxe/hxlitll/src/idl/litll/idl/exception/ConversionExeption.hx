package litll.idl.exception;
import litll.idl.generator.error.LoadIdlError;

class ConversionExeption extends IdlException
{
    public function new(message:String, read:Array<LoadIdlError>) {
        super(message);
    }
}
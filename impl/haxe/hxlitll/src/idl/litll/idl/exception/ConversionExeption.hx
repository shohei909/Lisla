package litll.idl.exception;
import litll.idl.generator.error.ReadIdlError;

class ConversionExeption extends IdlException
{
    public function new(message:String, read:Array<ReadIdlError>) {
        super(message);
    }
}
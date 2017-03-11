package litll.idl.library;
import hxext.error.ErrorBuffer;
import litll.idl.generator.error.ReadIdlError;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.litll2entity.LitllToEntityConfig;

class LoadTypesContext 
{
    public var errors:ErrorBuffer<ReadIdlError>;
    public var config(default, null):LitllToEntityConfig;
	
    public function new() 
    {
        errors = new ErrorBuffer();
        config = new LitllToEntityConfig();
    }
    
    public function addError(error:ReadIdlError):Void
    {
        errors.push(error);
    }
}
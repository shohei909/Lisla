package litll.idl.library;
import hxext.error.ErrorBuffer;
import litll.idl.generator.error.LoadIdlError;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.litll2entity.LitllToEntityConfig;

class LoadTypesContext 
{
    public var errors:ErrorBuffer<LoadIdlError>;
    public var config(default, null):LitllToEntityConfig;
	
    public function new() 
    {
        errors = new ErrorBuffer();
        config = new LitllToEntityConfig();
    }
    
    public function addError(error:LoadIdlError):Void
    {
        errors.push(error);
    }
}
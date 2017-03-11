package lisla.idl.library;
import hxext.error.ErrorBuffer;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.source.validate.ValidType;
import lisla.idl.lisla2entity.LislaToEntityConfig;

class LoadTypesContext 
{
    public var errors:ErrorBuffer<LoadIdlError>;
    public var config(default, null):LislaToEntityConfig;
	
    public function new() 
    {
        errors = new ErrorBuffer();
        config = new LislaToEntityConfig();
    }
    
    public function addError(error:LoadIdlError):Void
    {
        errors.push(error);
    }
}
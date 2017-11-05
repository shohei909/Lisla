package lisla.idl.library;
import lisla.idl.error.IdlModuleError;

class LibraryToCodeContext 
{
    
    public var errors(default, null):Array<IdlModuleError>;

    public function new(errors:Array<IdlModuleError>) 
    {
        this.errors = errors;
    }
    
    public function addError():Void
    {
        
    }
}
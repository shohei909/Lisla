package litll.idl.generator.source.validate;
import litll.idl.generator.source.file.IdlFilePath;
import litll.idl.generator.source.validate.InlinabilityOnTuple;
import litll.idl.std.entity.idl.TypeDefinition;
import litll.idl.std.entity.idl.TypePath;

class ValidType 
{
    public var file:IdlFilePath;
    public var typePath(default, null):TypePath;
    public var definition(default, null):TypeDefinition;
    public var inlinabilityOnTuple(default, null):InlinabilityOnTuple;
    
    public function new(
        file:String,
        typePath:TypePath,
        definition:TypeDefinition,
        inlinabilityOnTuple:InlinabilityOnTuple
    ) 
    {
        this.typePath = typePath;
        this.definition = definition;
        this.inlinabilityOnTuple = inlinabilityOnTuple;
    }
}

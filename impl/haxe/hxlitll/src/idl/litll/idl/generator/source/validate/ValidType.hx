package litll.idl.generator.source.validate;
import litll.idl.generator.output.data.store.HaxeDataInterface;
import litll.idl.generator.source.validate.InlinabilityOnTuple;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypePath;

class ValidType 
{
    public var typePath(default, null):TypePath;
    public var definition(default, null):TypeDefinition;
    public var inlinabilityOnTuple(default, null):InlinabilityOnTuple;
    
    public function new(
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

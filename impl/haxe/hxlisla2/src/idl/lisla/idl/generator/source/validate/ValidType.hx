package lisla.idl.generator.source.validate;
import lisla.idl.generator.source.validate.InlinabilityOnTuple;
import lisla.idl.std.entity.idl.TypeDefinition;
import lisla.idl.std.entity.idl.TypePath;
import lisla.project.ProjectRootAndFilePath;

class ValidType 
{
    public var file:ProjectRootAndFilePath;
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

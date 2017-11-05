package lisla.idl.code.generate.structure;
import lisla.idl.haxe.HaxeGenerateContext;

class StructureGenerateContext 
{
    public var parent(default, null):HaxeGenerateContext;
    public var pack(default, null):Array<String>;
    
    public function new(
        parent:HaxeGenerateContext,
        pack:Array<String>
    ) 
    {
        this.parent = parent;
        this.pack = pack;
    }
}

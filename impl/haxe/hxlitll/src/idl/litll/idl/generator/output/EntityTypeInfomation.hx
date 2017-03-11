package litll.idl.generator.output;
import litll.idl.generator.output.entity.EntityHaxeTypePath;
import litll.idl.generator.output.entity.store.HaxeEntityInterface;
import litll.idl.generator.output.entity.store.HaxeEntityInterfaceKind;
import litll.idl.generator.source.validate.InlinabilityOnTuple;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.std.entity.idl.TypeDefinition;
import litll.idl.std.entity.idl.TypePath;

class EntityTypeInfomation 
{
    public var dataInterface(default, null):HaxeEntityInterface;
    public var type(default, null):ValidType;
    
    // ========================
    // Getter
    // ========================
    public var kind(get, never):HaxeEntityInterfaceKind;
    private inline function get_kind():HaxeEntityInterfaceKind {
        return dataInterface.kind;
    }
	public var haxePath(get, never):EntityHaxeTypePath;
    private inline function get_haxePath():EntityHaxeTypePath {
        return dataInterface.path;
    }
    public var typePath(get, never):TypePath;
    private inline function get_typePath():TypePath {
        return type.typePath;
    }
    public var definition(get, never):TypeDefinition;
    private inline function get_definition():TypeDefinition {
        return type.definition;
    }
    public var inlinabilityOnTuple(get, never):InlinabilityOnTuple;
    private inline function get_inlinabilityOnTuple():InlinabilityOnTuple {
        return type.inlinabilityOnTuple;
    }

    public function new(type:ValidType, dataInterface:HaxeEntityInterface)
    {
        this.type = type;
        this.dataInterface = dataInterface;
    }
}

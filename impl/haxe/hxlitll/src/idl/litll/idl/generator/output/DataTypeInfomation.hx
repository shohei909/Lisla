package litll.idl.generator.output;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.generator.output.data.store.HaxeDataInterface;
import litll.idl.generator.output.data.store.HaxeDataInterfaceKind;
import litll.idl.generator.source.validate.InlinabilityOnTuple;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypePath;

class DataTypeInfomation 
{
    public var dataInterface(default, null):HaxeDataInterface;
    public var type(default, null):ValidType;
    
    // ========================
    // Getter
    // ========================
    public var kind(get, never):HaxeDataInterfaceKind;
    private inline function get_kind():HaxeDataInterfaceKind {
        return dataInterface.kind;
    }
	public var haxePath(get, never):HaxeDataTypePath;
    private inline function get_haxePath():HaxeDataTypePath {
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

    public function new(type:ValidType, dataInterface:HaxeDataInterface)
    {
        this.type = type;
        this.dataInterface = dataInterface;
    }
}

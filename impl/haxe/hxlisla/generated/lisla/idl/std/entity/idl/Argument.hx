// This file is generated by hxlisla.
package lisla.idl.std.entity.idl;
class Argument {
    public var name : lisla.idl.std.entity.idl.ArgumentName;
    public var type : lisla.idl.std.entity.idl.TypeReference;
    public var defaultValue : haxe.ds.Option<lisla.core.Lisla>;
    public function new(name:lisla.idl.std.entity.idl.ArgumentName, type:lisla.idl.std.entity.idl.TypeReference, defaultValue:haxe.ds.Option<lisla.core.Lisla>) {
        this.name = name;
        this.type = type;
        this.defaultValue = defaultValue;
    }
}
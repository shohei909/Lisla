// This file is generated by hxlisla.
package lisla.idl.std.entity.cli.clidl;
class CommandArgumentConfig {
    public var required : haxe.ds.Option<hxext.ds.Maybe<lisla.core.tag.ArrayTag>>;
    public var name : lisla.idl.std.entity.cli.clidl.NameConfig;
    public var common : lisla.idl.std.entity.cli.clidl.CommonConfig;
    public function new(required:haxe.ds.Option<hxext.ds.Maybe<lisla.core.tag.ArrayTag>>, name:lisla.idl.std.entity.cli.clidl.NameConfig, common:lisla.idl.std.entity.cli.clidl.CommonConfig) {
        this.required = required;
        this.name = name;
        this.common = common;
    }
}
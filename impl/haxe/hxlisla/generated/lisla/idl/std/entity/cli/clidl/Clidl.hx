// This file is generated by hxlisla.
package lisla.idl.std.entity.cli.clidl;
class Clidl {
    public var version : lisla.idl.std.entity.util.version.Version;
    public var about : lisla.core.LislaString;
    public var common : lisla.idl.std.entity.cli.clidl.CommonConfig;
    public function new(version:lisla.idl.std.entity.util.version.Version, about:lisla.core.LislaString, common:lisla.idl.std.entity.cli.clidl.CommonConfig) {
        this.version = version;
        this.about = about;
        this.common = common;
    }
}
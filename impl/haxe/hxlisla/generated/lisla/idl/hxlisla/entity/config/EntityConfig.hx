// This file is generated by hxlisla.
package lisla.idl.hxlisla.entity.config;
class EntityConfig {
    public var noOutput : haxe.ds.Option<hxext.ds.Maybe<lisla.core.tag.StringTag>>;
    public var filter : Array<lisla.idl.hxlisla.entity.config.FilterDeclaration>;
    public function new(noOutput:haxe.ds.Option<hxext.ds.Maybe<lisla.core.tag.StringTag>>, filter:Array<lisla.idl.hxlisla.entity.config.FilterDeclaration>) {
        this.noOutput = noOutput;
        this.filter = filter;
    }
}
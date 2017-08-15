// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.cli.clidl;
class CommandArgumentConfigLislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.std.entity.cli.clidl.CommandArgumentConfig, Array<lisla.idl.lisla2entity.error.LislaToEntityError>> return switch (context.lisla.kind) {
        case lisla.data.tree.al.AlTreeKind.Leaf(_):{
            hxext.ds.Result.Error(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.CantBeString));
        };
        case lisla.data.tree.al.AlTreeKind.Arr(array):{
            {
                var arg0 = haxe.ds.Option.None;
                for (lislaData in array) {
                    var context = new lisla.idl.lisla2entity.LislaToEntityContext(lislaData, context.config);
                    switch lislaData.kind {
                        case lislaData:return hxext.ds.Result.Error(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(lislaData, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.UnmatchedStructElement(["required", "name", "common"])));
                    };
                };
                var instance = new lisla.idl.std.entity.cli.clidl.CommandArgumentConfig(arg0);
                hxext.ds.Result.Ok(instance);
            };
        };
    };
}
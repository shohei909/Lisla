// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.cli.clidl;
class CommonConfigLislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.std.entity.cli.clidl.CommonConfig, Array<lisla.idl.lisla2entity.error.LislaToEntityError>> return switch (context.lisla.kind) {
        case lisla.data.tree.al.AlTreeKind.Leaf(_):{
            hxext.ds.Result.Error(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.CantBeString));
        };
        case lisla.data.tree.al.AlTreeKind.Arr(array):{
            {
                var arg0 = haxe.ds.Option.None;
                var arg1 = [];
                var arg2 = [];
                var arg3 = [];
                for (lislaData in array) {
                    var context = new lisla.idl.lisla2entity.LislaToEntityContext(lislaData, context.config);
                    switch lislaData.kind {
                        case lisla.data.tree.al.AlTreeKind.Arr(array) if (array.length == 2 && array[0].kind.match(lisla.data.tree.al.AlTreeKind.Leaf(_ => "description")) && array[1].kind.match(lisla.data.tree.al.AlTreeKind.Leaf(_))):switch (arg0) {
                            case haxe.ds.Option.Some(_):{
                                return hxext.ds.Result.Error(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(lislaData, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.StructElementDuplicated("description")));
                            };
                            case haxe.ds.Option.None:{
                                arg0 = haxe.ds.Option.Some({
                                    var context = new lisla.idl.lisla2entity.LislaToEntityContext(array[1], context.config);
                                    switch (lisla.idl.std.lisla2entity.StringLislaToEntity.process(context)) {
                                        case hxext.ds.Result.Ok(data):{
                                            data;
                                        };
                                        case hxext.ds.Result.Error(data):{
                                            return hxext.ds.Result.Error(data);
                                        };
                                    };
                                });
                            };
                        };
                        case lisla.data.tree.al.AlTreeKind.Arr(array) if (2 <= array.length && array[0].kind.match(lisla.data.tree.al.AlTreeKind.Leaf(_ => "subcommand")) && array[1].kind.match(lisla.data.tree.al.AlTreeKind.Leaf(_))):arg1.push(switch (lisla.idl.std.lisla2entity.cli.clidl.SubcommandLislaToEntity.process(context)) {
                            case hxext.ds.Result.Ok(data):{
                                data;
                            };
                            case hxext.ds.Result.Error(data):{
                                return hxext.ds.Result.Error(data);
                            };
                        });
                        case lisla.data.tree.al.AlTreeKind.Arr(array) if (2 <= array.length && array[0].kind.match(lisla.data.tree.al.AlTreeKind.Leaf(_ => "arg")) && array[1].kind.match(lisla.data.tree.al.AlTreeKind.Leaf(_))):arg2.push(switch (lisla.idl.std.lisla2entity.cli.clidl.CommandArgumentLislaToEntity.process(context)) {
                            case hxext.ds.Result.Ok(data):{
                                data;
                            };
                            case hxext.ds.Result.Error(data):{
                                return hxext.ds.Result.Error(data);
                            };
                        });
                        case lisla.data.tree.al.AlTreeKind.Arr(array) if (array.length == 2 && array[0].kind.match(lisla.data.tree.al.AlTreeKind.Leaf(_ => "input")) && array[1].kind.match(lisla.data.tree.al.AlTreeKind.Leaf(_ => "TypeReference"))):arg3.push(switch (lisla.idl.std.lisla2entity.cli.clidl.CommandInputLislaToEntity.process(context)) {
                            case hxext.ds.Result.Ok(data):{
                                data;
                            };
                            case hxext.ds.Result.Error(data):{
                                return hxext.ds.Result.Error(data);
                            };
                        });
                        case lislaData:return hxext.ds.Result.Error(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(lislaData, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.UnmatchedStructElement(["description", "subcommand", "arg", "input"])));
                    };
                };
                var instance = new lisla.idl.std.entity.cli.clidl.CommonConfig(arg0, arg1, arg2, arg3);
                hxext.ds.Result.Ok(instance);
            };
        };
    };
}
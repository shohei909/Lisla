// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.core;
class OptionLislaToEntity {
    public static function process<T>(context:lisla.idl.lisla2entity.LislaToEntityContext, tLislaToEntity):hxext.ds.Result<lisla.idl.std.entity.core.LislaOption<T>, Array<lisla.idl.lisla2entity.error.LislaToEntityError>> return switch context.lisla.kind {
        case lisla.data.tree.al.AlTreeKind.Arr(array) if (array.length == 0):{
            var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
            var data = hxext.ds.Result.Ok(lisla.idl.std.entity.core.LislaOption.None);
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    hxext.ds.Result.Error(error);
                };
            };
        };
        case lisla.data.tree.al.AlTreeKind.Arr(array) if (array.length == 1):{
            var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
            var data = {
                var arg0 = switch (arrayContext.read(tLislaToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Error(data):{
                        return hxext.ds.Result.Error(data);
                    };
                };
                hxext.ds.Result.Ok(lisla.idl.std.entity.core.LislaOption.Some(arg0));
            };
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    hxext.ds.Result.Error(error);
                };
            };
        };
        case data:hxext.ds.Result.Error(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.UnmatchedEnumConstructor(["none", "some"])));
    };
}
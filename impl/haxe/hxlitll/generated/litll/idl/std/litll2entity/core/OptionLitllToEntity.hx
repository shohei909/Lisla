// This file is generated by hxlitll.
package litll.idl.std.litll2entity.core;
class OptionLitllToEntity {
    public static function process<T>(context:litll.idl.litll2entity.LitllToEntityContext, tLitllToEntity):hxext.ds.Result<litll.idl.std.data.core.LitllOption<T>, litll.idl.litll2entity.LitllToEntityError> return switch context.litll {
        case litll.core.Litll.Arr(array) if (array.length == 0):{
            var arrayContext = new litll.idl.litll2entity.LitllToEntityArrayContext(array, 0, context.config);
            var data = hxext.ds.Result.Ok(litll.idl.std.data.core.LitllOption.None);
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    hxext.ds.Result.Err(error);
                };
            };
        };
        case litll.core.Litll.Arr(array) if (array.length == 1):{
            var arrayContext = new litll.idl.litll2entity.LitllToEntityArrayContext(array, 0, context.config);
            var data = {
                var arg0 = switch (arrayContext.read(tLitllToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                hxext.ds.Result.Ok(litll.idl.std.data.core.LitllOption.Some(arg0));
            };
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    hxext.ds.Result.Err(error);
                };
            };
        };
        case data:hxext.ds.Result.Err(litll.idl.litll2entity.LitllToEntityError.ofLitll(context.litll, litll.idl.litll2entity.LitllToEntityErrorKind.UnmatchedEnumConstructor(["none", "some"])));
    };
}
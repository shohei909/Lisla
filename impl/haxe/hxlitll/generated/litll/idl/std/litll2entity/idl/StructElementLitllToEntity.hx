// This file is generated by hxlitll.
package litll.idl.std.litll2entity.idl;
class StructElementLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.std.data.idl.StructElement, litll.idl.litll2entity.error.LitllToEntityError> return switch context.litll {
        case litll.core.Litll.Str(_):{
            hxext.ds.Result.Ok(litll.idl.std.data.idl.StructElement.Label(switch (litll.idl.std.litll2entity.idl.StructElementNameLitllToEntity.process(context)) {
                case hxext.ds.Result.Ok(data):{
                    data;
                };
                case hxext.ds.Result.Err(data):{
                    return hxext.ds.Result.Err(data);
                };
            }));
        };
        case litll.core.Litll.Arr(array) if (array.length == 1 && array.data[0].match(litll.core.Litll.Str(_))):{
            var arrayContext = new litll.idl.litll2entity.LitllToEntityArrayContext(array, 0, context.config);
            var data = {
                var arg0 = switch (arrayContext.read(litll.idl.std.litll2entity.idl.StructElementNameLitllToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                hxext.ds.Result.Ok(litll.idl.std.data.idl.StructElement.NestedLabel(arg0));
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
        case litll.core.Litll.Arr(array) if (2 <= array.length && array.length <= 3 && array.data[0].match(litll.core.Litll.Str(_))):{
            hxext.ds.Result.Ok(litll.idl.std.data.idl.StructElement.Field(switch (litll.idl.std.litll2entity.idl.StructFieldLitllToEntity.process(context)) {
                case hxext.ds.Result.Ok(data):{
                    data;
                };
                case hxext.ds.Result.Err(data):{
                    return hxext.ds.Result.Err(data);
                };
            }));
        };
        case data:hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(context.litll, litll.idl.litll2entity.error.LitllToEntityErrorKind.UnmatchedEnumConstructor(["nested_label"])));
    };
}
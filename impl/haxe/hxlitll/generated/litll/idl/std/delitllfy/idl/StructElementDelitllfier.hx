// This file is generated by hxlitll.
package litll.idl.std.delitllfy.idl;
class StructElementDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.std.data.idl.StructElement, litll.idl.delitllfy.DelitllfyError> return switch context.litll {
        case litll.core.Litll.Str(_):{
            litll.core.ds.Result.Ok(litll.idl.std.data.idl.StructElement.Label(switch (litll.idl.std.delitllfy.idl.StructElementNameDelitllfier.process(context)) {
                case litll.core.ds.Result.Ok(data):{
                    data;
                };
                case litll.core.ds.Result.Err(data):{
                    return litll.core.ds.Result.Err(data);
                };
            }));
        };
        case litll.core.Litll.Arr(array) if (array.length == 1 && array.data[0].match(litll.core.Litll.Str(_))):{
            var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(array, 0, context.config);
            var data = {
                var arg0 = switch (arrayContext.read(litll.idl.std.delitllfy.idl.StructElementNameDelitllfier.process)) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(data):{
                        return litll.core.ds.Result.Err(data);
                    };
                };
                litll.core.ds.Result.Ok(litll.idl.std.data.idl.StructElement.NestedLabel(arg0));
            };
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    litll.core.ds.Result.Err(error);
                };
            };
        };
        case litll.core.Litll.Arr(array) if (2 <= array.length && array.length <= 3 && array.data[0].match(litll.core.Litll.Str(_))):{
            litll.core.ds.Result.Ok(litll.idl.std.data.idl.StructElement.Field(switch (litll.idl.std.delitllfy.idl.StructFieldDelitllfier.process(context)) {
                case litll.core.ds.Result.Ok(data):{
                    data;
                };
                case litll.core.ds.Result.Err(data):{
                    return litll.core.ds.Result.Err(data);
                };
            }));
        };
        case data:litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.UnmatchedEnumConstructor(["nested_label"])));
    };
}
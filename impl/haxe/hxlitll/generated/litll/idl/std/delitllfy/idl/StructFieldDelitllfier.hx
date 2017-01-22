// This file is generated by hxlitll.
package litll.idl.std.delitllfy.idl;
class StructFieldDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.std.data.idl.StructField, litll.idl.delitllfy.DelitllfyError> {
        return switch (context.litll) {
            case litll.core.Litll.Str(string):{
                litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.CantBeString));
            };
            case litll.core.Litll.Arr(array):{
                var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(array, 0, context.config);
                var data = {
                    var arg0 = switch (arrayContext.read(litll.idl.std.delitllfy.idl.StructFieldNameDelitllfier.process)) {
                        case litll.core.ds.Result.Ok(data):{
                            data;
                        };
                        case litll.core.ds.Result.Err(error):{
                            return litll.core.ds.Result.Err(error);
                        };
                    };
                    var arg1 = switch (arrayContext.read(litll.idl.std.delitllfy.idl.TypeReferenceDelitllfier.process)) {
                        case litll.core.ds.Result.Ok(data):{
                            data;
                        };
                        case litll.core.ds.Result.Err(error):{
                            return litll.core.ds.Result.Err(error);
                        };
                    };
                    var arg2 = switch (arrayContext.readOptional(litll.idl.std.delitllfy.core.AnyDelitllfier.process)) {
                        case litll.core.ds.Result.Ok(data):{
                            data;
                        };
                        case litll.core.ds.Result.Err(error):{
                            return litll.core.ds.Result.Err(error);
                        };
                    };
                    var instance = new litll.idl.std.data.idl.StructField(arg0, arg1, arg2);
                    litll.core.ds.Result.Ok(instance);
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
        };
    }
}
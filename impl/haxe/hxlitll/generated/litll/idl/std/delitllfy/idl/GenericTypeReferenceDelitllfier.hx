// This file is generated by hxlitll.
package litll.idl.std.delitllfy.idl;
class GenericTypeReferenceDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.std.data.idl.GenericTypeReference, litll.idl.delitllfy.DelitllfyError> {
        return switch (context.litll) {
            case litll.core.Litll.Str(string):{
                litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofString(string, litll.core.ds.Maybe.none(), litll.idl.delitllfy.DelitllfyErrorKind.CantBeString));
            };
            case litll.core.Litll.Arr(data):{
                var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(data, 0, context.config);
                var data = {
                    var arg0 = switch (arrayContext.read(litll.idl.std.delitllfy.idl.TypePathDelitllfier.process)) {
                        case litll.core.ds.Result.Ok(data):{
                            data;
                        };
                        case litll.core.ds.Result.Err(error):{
                            return litll.core.ds.Result.Err(error);
                        };
                    };
                    var arg1 = switch (arrayContext.readRest(litll.idl.std.delitllfy.idl.TypeReferenceParameterDelitllfier.process)) {
                        case litll.core.ds.Result.Ok(data):{
                            data;
                        };
                        case litll.core.ds.Result.Err(error):{
                            return litll.core.ds.Result.Err(error);
                        };
                    };
                    var instance = new litll.idl.std.data.idl.GenericTypeReference(arg0, arg1);
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